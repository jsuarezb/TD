package td.util;

import haxe.ds.IntMap;

import openfl.Assets;
import openfl.events.EventDispatcher;

import td.entity.*;
import td.view.components.GameStage;
import td.events.EnemyEvent;
import td.events.RoundEvent;

class Level extends EventDispatcher {

    public static inline var BASE_DESTROYED : String = "base_destroyed";

    public static inline var ENEMIES_DESTROYED : String = "enemies_destroyed";

    private static inline var LEVELS_PATH : String = "assets/levels.json";

    private var levelNumber : Int;

    private var gameStage : GameStage;

    private var rounds : Array<Round>;

    private var roundsEnded : IntMap <Round>;

    public function new (level : Int, gameStage : GameStage)
    {
        super ();

        this.levelNumber = level;
        this.gameStage = gameStage;
        this.rounds = new Array<Round> ();
        this.roundsEnded = new IntMap<Round> ();

        this.loadRounds ();
    }

    /**
     * Load every round corresponding to this level from the levels
     * file stored in /Assets/
     */
    public function loadRounds () : Void
    {
        var json = Assets.getText (LEVELS_PATH);
        var levels = haxe.Json.parse (json);
        var rounds : Array<Dynamic> = levels[levelNumber].rounds;

        var round : Round;
        for (data in rounds)
        {
            round = new Round (
                data.id,
                data.enemyType,
                data.level,
                data.zones,
                data.timer,
                data.amount,
                data.dependencies
            );

            round.addEventListener (EnemyEvent.SENT, sendEnemy);
            round.addEventListener (RoundEvent.END, onRoundEnd);

            this.rounds.push (round);
        }
    }

    /**
     * Start the level
     */
    public function start () : Void
    {
        for (round in this.rounds)
            if (!round.isActive () && canStart (round))
                round.start ();
    }

    /**
     * Callback to be called when a round needs to send an enemy
     */
    private function sendEnemy (e : EnemyEvent) : Void
    {
        gameStage.addEnemy (e.enemy);
    }

    /**
     * Callback to be called when a round ends
     */
    private function onRoundEnd (e : RoundEvent) : Void
    {
        var round = e.round;
        this.rounds.remove (round);
        this.roundsEnded.set (round.getId (), round);

        for (round in this.rounds)
            if (!round.isActive () && canStart (round))
                round.start ();
    }

    /**
     * Decide wether or not a round can be started
     * @param r round
     */
    private function canStart (r : Round) : Bool
    {
        if (r.dependsOn () == null || r.dependsOn ().length == 0)
            return true;

        for (dependency in r.dependsOn ())
            if (!this.roundsEnded.exists (dependency))
                return false;

        return true;
    }

    /**
     * Return the enemies remaining
     * @return  level's enemies remaining
     */
    public function enemiesRemaining () : Int
    {
        var s = 0;

        for (round in rounds)
            s += round.enemiesRemaining();

        return s;
    }

    /**
     * Pause the rounds, preventing spawning enemies or ending
     */
    public function pause () : Void
    {
        for (r in rounds)
            r.pause ();
    }

    /**
     * Resume the rounds, allowing spawning enemies or ending
     */
    public function resume () : Void
    {
        for (r in rounds)
            r.resume ();
    }

    /**
     * Destroys all the listeners
     */
    public function destroy () : Void
    {
        for (r in rounds)
        {
            r.destroy ();
            r.addEventListener (EnemyEvent.SENT, sendEnemy);
            r.addEventListener (RoundEvent.END, onRoundEnd);
        }
    }

}

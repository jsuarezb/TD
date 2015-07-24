package td.util;

import haxe.ds.IntMap;

import openfl.Assets;
import openfl.events.EventDispatcher;

import td.entity.*;
import td.view.components.GameStage;
import td.event.EnemyEvent;
import td.event.RoundEvent;

class Level extends EventDispatcher {

    public static inline var BASE_DESTROYED : String = "base_destroyed";

    public static inline var ENEMIES_DESTROYED : String = "enemies_destroyed";

    private static inline var LEVELS_PATH : String = "assets/levels.json";

    private var levelNumber : Int;

    private var gameStage : GameStage;

    private var rounds : Array<Round>;

    private var roundsEnded : IntMap <Round>;


    /* TODO finish round dependencies */
    public function new (level : Int, gameStage : GameStage)
    {
        super ();

        this.levelNumber = level;
        this.gameStage = gameStage;
        this.rounds = new Array<Round> ();
        this.roundsEnded = new IntMap<Round> ();

        this.loadRounds ();
    }

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

    public function start () : Void
    {
        for (round in this.rounds)
            if (!round.isActive () && canStart (round))
                round.start ();
    }

    private function sendEnemy (e : EnemyEvent) : Void
    {
        gameStage.addEnemy (e.enemy);
    }

    private function onRoundEnd (e : RoundEvent) : Void
    {
        var round = e.round;
        this.rounds.remove (round);
        this.roundsEnded.set (round.getId (), round);

        for (round in this.rounds)
            if (!round.isActive () && canStart (round))
                round.start ();
    }

    private function canStart (r : Round) : Bool
    {
        if (r.dependsOn () == null || r.dependsOn ().length == 0)
            return true;

        for (dependency in r.dependsOn ())
            if (!this.roundsEnded.exists (dependency))
                return false;

        return true;
    }

    public function enemiesRemaining () : Int
    {
        var s = 0;

        for (round in rounds)
            s += round.enemiesRemaining();

        return s;
    }

    public function pause () : Void
    {
        for (r in rounds)
            r.pause ();
    }

    public function resume () : Void
    {
        for (r in rounds)
            r.resume ();
    }

}

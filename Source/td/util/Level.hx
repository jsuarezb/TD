package td.util;

import openfl.Assets;
import openfl.events.EventDispatcher;

import td.entity.*;
import td.util.*;
import td.event.EnemyEvent;

class Level extends EventDispatcher {

    private static inline var LEVELS_PATH : String = "assets/levels.json";

    private var levelNumber : Int;

    private var gameStage : GameStage;

    private var rounds : Array<Round>;

    public function new (level : Int, gameStage : GameStage)
    {
        super ();

        this.levelNumber = level;
        this.gameStage = gameStage;
        this.rounds = new Array<Round> ();

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
            round = new Round (data.enemyType, data.level, data.zones, data.timer, data.amount);
            round.addEventListener (EnemyEvent.SENT, sendEnemy);

            this.rounds.push (round);
        }
    }

    public function start () : Void
    {
        for (round in this.rounds)
        {
            round.tick ();
            round.addEventListener (EnemyEvent.SENT, sendEnemy);
        }
    }

    private function sendEnemy (e:EnemyEvent)
    {
        trace (e);
        gameStage.addEnemy (e.enemy);
    }

}

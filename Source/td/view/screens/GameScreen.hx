package td.view.screens;

import openfl.display.Sprite;

import td.entity.tower.*;
import td.view.components.*;
import td.event.*;

class GameScreen extends Sprite
{

    private static inline var GAME_STAGE_WIDTH : Int = 600;

    private static inline var GAME_STAGE_HEIGHT : Int = 600;

    private var gStage : GameStage;

    private var statsPanel : GamePanel;

    private var score : Int = 0;

    public function new ()
    {
        super ();

        this.gStage = new GameStage (GameScreen.GAME_STAGE_WIDTH, GameScreen.GAME_STAGE_HEIGHT);
        setUpGameStage ();

        addChild (this.gStage);

        this.statsPanel = new GamePanel ();
        addChild (this.statsPanel);

		gStage.startLevel ();
    }

    public function setUpGameStage () : Void
    {
        var t = Tower.create (Tower.BASIC_TOWER, 20);
		t.x = 400;
		t.y = 300;
		this.gStage.addTower (t);

        var t = Tower.create (Tower.SATELLITE_TOWER, 1);
        t.x = 500;
        t.y = 300;
        this.gStage.addTower (t);

		this.gStage.setLevel (0);

        this.gStage.addEventListener(EnemyEvent.DEAD, onEnemyDead, true);
    }

    private function onEnemyDead (e : EnemyEvent) : Void
    {
        this.score += e.enemy.getScore ();
        this.statsPanel.updateScore (score);
    }

}

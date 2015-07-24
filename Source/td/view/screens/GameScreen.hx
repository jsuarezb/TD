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

    private var hud : GamePanel;

    private var score : Int = 0;

    public function new ()
    {
        super ();

        gStage = new GameStage (GameScreen.GAME_STAGE_WIDTH, GameScreen.GAME_STAGE_HEIGHT);
        setUpGameStage ();

        addChild (gStage);

        hud = new GamePanel ();
        addChild (hud);

		gStage.startLevel ();
    }

    public function setUpGameStage () : Void
    {
		gStage.setLevel (0);

        gStage.addEventListener (EnemyEvent.DEAD, onEnemyDead, true);
        gStage.addEventListener (GameEvent.PAUSE, onPause);
        gStage.addEventListener (GameEvent.RESUME, onResume);
    }

    private function onEnemyDead (e : EnemyEvent) : Void
    {
        score += e.enemy.getScore ();
        hud.updateScore (score);
    }

    public function onPause (e : GameEvent) : Void
    {
        hud.pause ();
    }

    public function onResume (e: GameEvent) : Void
    {
        hud.resume ();
    }
    
}

package td.view.screens;

import openfl.display.Sprite;
import openfl.events.Event;

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
        hud = new GamePanel ();

        setUpGameStage ();
        addChild (gStage);
        addChild (hud);

        addEventListener (Event.ADDED_TO_STAGE, onAdded);
    }

    /**
     * Set all the variables and listeners into the game stage
     */
    public function setUpGameStage () : Void
    {
		gStage.setLevel (0);

        gStage.addEventListener (EnemyEvent.DEAD, onEnemyDead, true);
        gStage.addEventListener (GameEvent.PAUSE, onPause);
        gStage.addEventListener (GameEvent.RESUME, onResume);
    }

    /**
     * Callback of the Event.ADDED_TO_STAGE event
     * @param   e   event
     */
    private function onAdded (e : Event) : Void
    {
        removeEventListener (Event.ADDED_TO_STAGE, onAdded);

		gStage.startLevel ();

        stage.addEventListener (Event.DEACTIVATE, function (e : Event) {
            gStage.pause ();
        });

        stage.addEventListener (Event.ACTIVATE, function (e : Event) {
            gStage.resume ();
        });
    }

    /**
     * Callback to be executed when an enemy dies
     * @param   e   enemy event
     */
    private function onEnemyDead (e : EnemyEvent) : Void
    {
        score += e.enemy.getScore ();
        hud.updateScore (score);
    }

    /**
     * Callback to be executed when the game is paused
     * @param   e   game event
     */
    public function onPause (e : GameEvent) : Void
    {
        hud.pause ();
    }

    /**
     * Callback to be executed when the game is paused
     * @param   e   game event
     */
    public function onResume (e : GameEvent) : Void
    {
        hud.resume ();
    }

}

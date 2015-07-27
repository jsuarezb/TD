package td.view.screens;

import openfl.display.Sprite;
import openfl.events.Event;

import td.entity.tower.*;
import td.view.components.*;
import td.events.*;

class GameScreen extends Screen
{

    private var gStage : GameStage;

    private var hud : GamePanel;

    private var score : Int = 0;

    public function new ()
    {
        super ();

        gStage = new GameStage (Screen.WIDTH, Screen.HEIGHT);
        hud = new GamePanel ();

        setUpGameStage ();
        addChild (gStage);
        addChild (hud);

        addEventListener (Event.ADDED_TO_STAGE, onAdded);
    }

    /**
     * Set all the listeners into the game stage
     */
    public function setUpGameStage () : Void
    {
        gStage.addEventListener (EnemyEvent.DEAD, onEnemyDead, true);
        gStage.addEventListener (GameEvent.PAUSE, onPause);
        gStage.addEventListener (GameEvent.RESUME, onResume);
        gStage.addEventListener (TowerEvent.HIGHLIGHT, onTowerHighlighted);
        gStage.addEventListener (TowerEvent.UNHIGHLIGHT, onTowerUnhighlighted);
    }

    /**
     * Callback of the Event.ADDED_TO_STAGE event
     * @param   e   event
     */
    private function onAdded (e : Event) : Void
    {
        removeEventListener (Event.ADDED_TO_STAGE, onAdded);

		gStage.startLevel (0);

        stage.addEventListener (Event.DEACTIVATE, function (e : Event) {
            gStage.pause ();
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

    private function onTowerHighlighted (e : TowerEvent) : Void
    {
        hud.showTowerDetails (e.tower);
    }

    private function onTowerUnhighlighted (e : TowerEvent) : Void
    {
        hud.hideTowerDetails ();
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

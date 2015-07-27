package td.view.screens;

import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.display.GradientType;
import openfl.events.Event;
import openfl.geom.Matrix;

import td.events.ScreenEvent;

class ScreenContainer extends Sprite
{

    private var currentScreen : Screen;

    private var transitionEffect : Shape;

    private var bg : Shape;

    public function new (screen : Screen)
    {
        super ();

        bg = new Shape ();
        addChild (bg);

        transitionEffect = new Shape ();
        addScreen (screen);

        addEventListener (Event.ADDED_TO_STAGE, onAdded);
    }

    /**
     * Hide the current screen and shows the specified screen
     * @param   screen  screen to be shown at the end of the transition
     */
    public function transitionTo (screen : Screen) : Void
    {
        currentScreen.destroy ();

        removeChild (currentScreen);
        removeChild (transitionEffect);

        addScreen (screen);
    }

    /**
     * Show the screen
     * @param   screen  screen to be shown
     */
    private function addScreen (screen : Screen) : Void
    {
        currentScreen = screen;
        transitionEffect.alpha = 1;

        addChild (currentScreen);
        addChild (transitionEffect);

        currentScreen.addEventListener (ScreenEvent.TRANSITION, onScreenTransition);
    }

    private function drawBackground () : Void
    {
        var mtx : Matrix = new Matrix ();
        mtx.createGradientBox (stage.stageWidth, stage.stageHeight, Math.PI / 4, 0, 0);

        bg.graphics.beginGradientFill (
            GradientType.LINEAR,
            [0xF24A87, 0xF8A248],
            [1, 1],
            [0, 255],
            mtx
        );
        bg.graphics.drawRect (0, 0, stage.stageWidth, stage.stageHeight);
        bg.graphics.endFill ();
    }

    private function drawTransition () : Void
    {
        transitionEffect.graphics.beginFill (0xFFFFFF);
        transitionEffect.graphics.drawRect (0, 0, stage.stageWidth, stage.stageHeight);
        transitionEffect.graphics.endFill ();
    }

    /**
     * Callback to execute when container is added
     */
    private function onAdded (e : Event) : Void
    {
        removeEventListener (Event.ADDED_TO_STAGE, onAdded);

        drawBackground ();
        drawTransition ();

        addChild (currentScreen);
        addChild (transitionEffect);

        addEventListener (Event.ENTER_FRAME, onEnter);
    }

    /**
     * Callback to execute every frame
     */
    private function onEnter (e : Event) : Void
    {
        if (transitionEffect.alpha > 0) transitionEffect.alpha -= 0.01;
        else transitionEffect.alpha = 0;
    }

    /**
     * Callback to execute on screen transition
     */
    private function onScreenTransition (e : ScreenEvent) : Void
    {
        currentScreen.removeEventListener (ScreenEvent.TRANSITION, onScreenTransition);

        transitionTo (e.screen);
    }

}

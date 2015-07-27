package td.view.screens;

import openfl.display.Sprite;

import td.events.ScreenEvent;

class Screen extends Sprite {

    public static inline var WIDTH : Int = 600;

    public static inline var HEIGHT : Int = 600;

    public function new ()
    {
        super ();
    }

    /**
     * Ask for a transition to another screen
     * @param   screen  screen to be shown next
     */
    public function transitionTo (screen : Screen)
    {
        dispatchEvent (new ScreenEvent (ScreenEvent.TRANSITION, screen));
    }

    /**
     * To be implemented by deriving classes
     * Destroy all the listeners inside the screen
     */
    public function destroy () : Void { }

}

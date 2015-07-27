package td.events;

import openfl.events.Event;

import td.view.screens.Screen;

class ScreenEvent extends Event
{

    public static inline var TRANSITION : String = "screen_transition";

    public var screen : Screen;

    public function new (label : String, screen : Screen, bubbles : Bool = false, cancelable : Bool = false)
    {
        super (label, bubbles, cancelable);

        this.screen = screen;
    }

}

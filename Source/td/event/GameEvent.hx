package td.event;

import openfl.events.Event;

import td.entity.enemy.*;

class GameEvent extends Event
{

    public static inline var PAUSE : String = "game_pause";

    public static inline var RESUME : String = "game_resume";

    public function new (label : String, bubbles : Bool = false, cancelable : Bool = false)
    {
        super (label, bubbles, cancelable);
    }

}

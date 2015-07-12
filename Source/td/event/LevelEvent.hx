package td.event;

import openfl.events.Event;

class LevelEvent extends Event {

    public static inline var END : String = "level_end";

    public function new (label : String, bubbles : Bool = false, cancelable : Bool = false)
    {
        super (label, bubbles, cancelable);
    }

}

package td.event;

import openfl.events.Event;

class PlayerBaseEvent extends Event
{

    public static inline var BASE_DESTROYED : String = "base_destroyed";

    public function new (label : String, bubbles : Bool = false, cancelable : Bool = false)
    {
        super (label, bubbles, cancelable);
    }

}

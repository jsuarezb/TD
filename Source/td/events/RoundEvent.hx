package td.events;

import openfl.events.Event;

import td.entity.enemy.*;
import td.util.Round;

class RoundEvent extends Event
{

    public static inline var END : String = "round_end";

    public var round : Round;

    public function new (label : String, round : Round, bubbles : Bool = false, cancelable : Bool = false)
    {
        super (label, bubbles, cancelable);

        this.round = round;
    }

}

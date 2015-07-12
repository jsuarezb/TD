package td.event;

import openfl.events.Event;

import td.entity.enemy.*;

class EnemyEvent extends Event
{

    public static inline var SENT : String = "enemy_sent";

    public static inline var DEAD : String = "enemy_dead";

    public var enemy : Enemy;

    public function new (label : String, enemy : Enemy, bubbles : Bool = false, cancelable : Bool = false)
    {
        super (label, bubbles, cancelable);

        this.enemy = enemy;
    }

}

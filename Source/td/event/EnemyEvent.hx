package td.event;

import openfl.events.Event;

import td.util.EnemyData;

class EnemyEvent extends Event
{

    public static inline var SENT : String = "enemy_sent";

    public var enemyData : EnemyData;

    public function new (label : String, enemyData : EnemyData, bubbles : Bool = false, cancelable : Bool = false)
    {
        super (label, bubbles, cancelable);

        this.enemyData = enemyData;
    }

}

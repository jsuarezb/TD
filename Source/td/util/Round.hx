package td.util;

import haxe.Timer;
import openfl.events.EventDispatcher;
import openfl.events.Event;
import openfl.events.TimerEvent;
import openfl.utils.Timer;

import td.util.EnemyData;
import td.event.EnemyEvent;

class Round extends EventDispatcher
{

    public var enemyData : EnemyData;

    private var timer : Timer;

    public function new ()
    {
        super ();
    }

    public function tick () : Void
    {
        var time = Math.random () * (enemyData.timer.max - enemyData.timer.min) + enemyData.timer.min;

        timer = new Timer (time);

        timer.addEventListener (TimerEvent.TIMER, onTimer);
        timer.start ();
    }

    private function onTimer (e : TimerEvent) : Void
    {
        trace ("On Timer");
        var e = new EnemyEvent (EnemyEvent.SENT, enemyData);

        dispatchEvent (e);
    }

}

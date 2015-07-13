package td.util;

import haxe.Timer;
import openfl.events.EventDispatcher;
import openfl.events.Event;
import openfl.events.TimerEvent;
import openfl.utils.Timer;

import td.entity.enemy.Enemy;
import td.event.EnemyEvent;

class Round extends EventDispatcher
{

    private var enemy : String;

    private var level : Dynamic;

    private var zones : Array<Int>;

    private var timeInterval : Dynamic;

    private var timer : Timer;

    private var amount : Int;

    public function new (enemy : String, level : Dynamic, zones : Array<Int>, timeInterval : Dynamic, amount : Int)
    {
        super ();

        this.enemy = enemy;
        this.level = level;
        this.zones = zones;
        this.timeInterval = timeInterval;
        this.amount = amount;
    }

    public function enemiesRemaining () : Int
    {
        return this.amount;
    }

    public function tick () : Void
    {
        var time = Math.random () * (this.timeInterval.max - this.timeInterval.min) + this.timeInterval.min;

        timer = new Timer (time);

        timer.addEventListener (TimerEvent.TIMER, onTimer);
        timer.start ();
    }

    private function onTimer (e : TimerEvent) : Void
    {
        if (amount == 0) {
            timer.removeEventListener (TimerEvent.TIMER, onTimer);
            return;
        }

        var enemy = Enemy.create (this.enemy, this.level, this.zones);
        var event = new EnemyEvent (EnemyEvent.SENT, enemy);

        dispatchEvent (event);
        amount--;
    }

}

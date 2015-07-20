package td.util;

import haxe.Timer;
import openfl.events.EventDispatcher;
import openfl.events.Event;
import openfl.events.TimerEvent;
import openfl.utils.Timer;

import td.entity.enemy.Enemy;
import td.event.EnemyEvent;
import td.event.RoundEvent;

class Round extends EventDispatcher
{

    private var id : Int;

    private var enemy : String;

    private var level : Dynamic;

    private var zones : Array<Int>;

    private var timeInterval : Dynamic;

    private var amount : Int;

    private var dependencies : Null<Array<Int>>;

    private var active : Bool = false;

    private var timer : Timer;

    public function new (id : Int, enemy : String, level : Dynamic,
        zones : Array<Int>, timeInterval : Dynamic, amount : Int,
        dependencies : Null<Array<Int>>)
    {
        super ();

        this.id = id;
        this.enemy = enemy;
        this.level = level;
        this.zones = zones;
        this.timeInterval = timeInterval;
        this.amount = amount;
        this.dependencies = dependencies;
    }

    public function enemiesRemaining () : Int
    {
        return this.amount;
    }

    public function start () : Void
    {
        this.active = true;
        this.tick ();
    }

    public function tick () : Void
    {
        var time = Math.random () * (this.timeInterval.max - this.timeInterval.min) + this.timeInterval.min;

        this.timer = new Timer (time);

        this.timer.addEventListener (TimerEvent.TIMER, onTimer);
        this.timer.start ();
    }

    public function getId () : Int
    {
        return this.id;
    }

    public function dependsOn () : Null<Array<Int>>
    {
        return this.dependencies;
    }

    public function isActive () : Bool
    {
        return this.active;
    }

    private function onTimer (e : TimerEvent) : Void
    {
        if (amount == 0) {
            timer.removeEventListener (TimerEvent.TIMER, onTimer);
            dispatchEvent (new RoundEvent (RoundEvent.END, this));

            return;
        }

        var enemy = Enemy.create (this.enemy, this.level, this.zones);
        var event = new EnemyEvent (EnemyEvent.SENT, enemy);

        dispatchEvent (event);
        amount--;
    }

}

package td.entity.tower;

import openfl.utils.Timer;
import openfl.events.TimerEvent;

import td.entity.Attacker;

class AttackTower extends Tower implements Attacker
{

    public var damage : Float;

    public var rateOfFire : Float;

    public var kills : Int;

    public var timer : Timer;

    public function new ()
    {
        super ();
    }

    public function inflictDamage (e : Entity) : Void
    {
        e.takeDamage (this, this.damage);
    }

    public function addKill () : Void
    {
        this.kills++;
    }

    public function shoot (e : TimerEvent) : Void { }

    override public function pause () : Void
    {
        timer.stop ();
    }

    override public function resume () : Void
    {
        timer.start ();
    }

    override public function destroy () : Void
    {
        timer.removeEventListener (TimerEvent.TIMER, shoot);
    }

}

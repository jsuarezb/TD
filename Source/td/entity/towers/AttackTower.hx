package td.entity.towers;

import openfl.display.Sprite;
import openfl.events.TimerEvent;
import openfl.utils.Timer;

import td.entity.Attacker;
import td.entity.enemy.Enemy;

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

    /**
     * Damage an entity
     * @param   e   entity to damage
     */
    public function inflictDamage (e : Entity) : Void
    {
        e.takeDamage (this, this.damage);
    }

    /**
     * Add a kill to the tower
     */
    public function addKill () : Void
    {
        this.kills++;
    }

    /**
     * Check whether `e` is inside the tower's range
     * @param   e   sprite to Check
     * @return  true if `e` is inside range, false if not
     */
    public function inRange (e : Sprite) : Bool { return false; }

    /**
     * Search the target and attack it
     * @param   e   timer event
     */
    public function shoot (e : TimerEvent) : Void {}

    /**
     * Specific attack of each tower
     * @param   enemy   enemy to be attacked
     */
    public function attack (enemy : Enemy) : Void {}

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

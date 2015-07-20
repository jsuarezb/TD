package td.entity.tower;

import td.entity.Attacker;

class AttackTower extends Tower implements Attacker
{

    public var damage : Float;

    public var rateOfFire : Float;

    public var kills : Int;

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

}

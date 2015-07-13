package td.entity;

interface Entity
{

    public function takeDamage (e : Entity, d : Float) : Void;

    public function inflictDamage (e : Entity) : Void;

}

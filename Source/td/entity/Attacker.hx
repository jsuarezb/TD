package td.entity;

interface Attacker extends Entity
{

    /**
     * Add a kill to the entity
     */
    public function addKill () : Void;

    /**
     * Inflict damage on `e`
     */
    public function inflictDamage (e : Entity) : Void;

}

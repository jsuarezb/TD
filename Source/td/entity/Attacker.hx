package td.entity;

import td.entity.enemy.Enemy;

interface Attacker extends Entity
{

    /**
     * Add a kill to the entity
     */
    public function addKill () : Void;

    /**
     * Attack enemy
     */
    public function attack (e : Enemy) : Void;

    /**
     * Inflict damage on `e`
     */
    public function inflictDamage (e : Entity) : Void;

}

package td.entity;

import openfl.display.Sprite;

import td.event.PlayerBaseEvent;

class PlayerBase extends Sprite implements Entity
{

    private var hp : Float;

    public function new ()
    {
        super ();

        this.hp = 100;
    }

    public function takeDamage (e : Entity, d : Float) : Void
    {
        this.hp -= d;

        if (this.hp <= 0) {
            dispatchEvent (new PlayerBaseEvent (PlayerBaseEvent.BASE_DESTROYED));
        }
    }

    /**
     * Not implemented. In case the base some day will damage enemies.
     */
    public function inflictDamage (e : Entity) : Void {}



}

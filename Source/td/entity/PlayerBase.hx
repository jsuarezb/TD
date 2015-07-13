package td.entity;

import openfl.display.Sprite;

class PlayerBase extends Sprite implements Entity
{

    private var hp : Float;

    public function new ()
    {
        super ();

        this.hp = 100;
    }


}

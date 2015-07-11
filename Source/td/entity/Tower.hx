package td.entity;

import openfl.display.Sprite;

class Tower extends Sprite
{

    // Status variables
    private var damage : Float;

    private var speed : Float;

    private var rateOfFire : Float;

    private var range : Float;

    private var kills : Int;

    // Internal variables
    private var isSelected : Bool = false;

    private var xSpeed : Float = 0;

    private var ySpeed : Float = 0;

    private var xNext : Float;

    private var yNext : Float;

/*
    TODO
    var status:Array<TowerStatus>;

    var items:Array<Item>;
*/

    public function new (damage : Float, speed : Float, rateOfFire : Float,
            range : Float, kills : Float)
    {
        this.damage = damage;
        this.speed = speed;
        this.rateOfFire = rateOfFire;
        this.range = range;
        this.kills = kills;
    }

    public function moveTo (x : Float, y : Float) : Void
    {
        if (!isSelected) return;

        this.xNext = x;
        this.yNext = y;
    }

    public function move () : Void
    {
        var xDif = x - this.x;
        var yDif = y - this.y;
        var dist = Math.sqrt(yDif * yDif + xDif * xDif);

        if (dist < this.speed) {
            this.x = this.xNext;
            this.y = this.yNext;
        } else {
            var angle = Math.atan2(yDif, xDif);

            this.x += Math.cos(angle) * this.speed;
            this.y += Math.sin(angle) * this.speed;
        }
    }

}

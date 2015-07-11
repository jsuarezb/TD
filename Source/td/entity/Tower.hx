package td.entity;

import openfl.display.Sprite;

class Tower extends Sprite
{

    private static inline var WIDTH = 10;

    private static inline var HEIGHT = 10;

    // Status variables
    private var damage : Float;

    private var speed : Float;

    private var rateOfFire : Float;

    private var range : Float;

    private var kills : Int;

    // Internal variables
    public var isSelected : Bool = false;

    private var isMoving : Bool = false;

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
            range : Float, kills : Int)
    {
        super ();

        this.damage = damage;
        this.speed = speed;
        this.rateOfFire = rateOfFire;
        this.range = range;
        this.kills = kills;

        this.draw ();
    }

    private function draw () : Void
    {
        this.graphics.lineStyle(2, 0);
        this.graphics.drawRect(0, 0, Tower.WIDTH, Tower.HEIGHT);
    }

    public function moveTo (x : Float, y : Float) : Void
    {
        if (!isSelected) return;

        this.xNext = x;
        this.yNext = y;
        this.isMoving = true;
    }

    public function move () : Void
    {
        if (!this.isMoving) return;

        var xDif = this.xNext - this.x;
        var yDif = this.yNext - this.y;
        var dist = Math.sqrt(yDif * yDif + xDif * xDif);

        if (dist <= this.speed) {
            this.isMoving = false;

            this.x = this.xNext;
            this.y = this.yNext;
        } else {
            var angle = Math.atan2(yDif, xDif);

            this.x += Math.cos(angle) * this.speed;
            this.y += Math.sin(angle) * this.speed;
        }
    }

}

package td.entity;

import openfl.display.Sprite;
import td.entity.tower.*;

class Tower extends Sprite
{

    // Tower types
    public static inline var SIMPLE_TOWER : String = "simple_tower";

    public static inline var SPLASH_TOWER : String = "splash_tower";

    public static inline var LASER_TOWER : String = "laser_tower";

    public static inline var SNIPER_TOWER : String = "sniper_tower";

    public static inline var POISON_TOWER : String = "poison_tower";

    // Tower dimensions
    private static inline var WIDTH = 15;

    private static inline var HEIGHT = 15;

    // Serializable variables
    public var damage : Float;

    public var speed : Float;

    public var rateOfFire : Float;

    public var range : Float;

    public var kills : Int;

    public var level : Int;

    // In-game variables
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

    public function new ()
    {
        super ();

        this.draw ();
    }

    public static function create (tower : String, level : Int, kills : Int) : Tower {
        switch (tower) {
            case Tower.SIMPLE_TOWER:
                return new SimpleTower (level, kills);

        }

        return null;
    }

    public function draw () : Void
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

    public function shoot () : Void {}

}

package td.entity.tower;

import openfl.display.Sprite;

import td.entity.Entity;
import td.entity.Attacker;
import td.entity.enemy.Enemy;
import td.util.GameStage;

class Tower extends Sprite implements Attacker
{

    // Tower types
    public static inline var BASIC_TOWER : String = "basic_tower";

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

    public var index : Int;

    private var gameStage : GameStage;

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

    public static function create (tower : String, level : Int, kills : Int) : Tower
    {
        switch (tower)
        {
            case Tower.BASIC_TOWER:
                return new BasicTower (level, kills);

            case Tower.SPLASH_TOWER:
                return new SplashTower (level, kills);

            case Tower.SNIPER_TOWER:
                return new SniperTower (level, kills);

            default:
                return null;

        }
    }

    public function draw () : Void
    {
        /*this.graphics.lineStyle(2, 0x92C8B7);
        this.graphics.drawRect(
            -Tower.WIDTH / 2,
            -Tower.HEIGHT / 2,
            Tower.WIDTH,
            Tower.HEIGHT
        );*/
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

    public function setGameStage (gameStage : GameStage) : Void
    {
        this.gameStage = gameStage;
    }

    public function sqrDistanceTo (enemy : Enemy) : Float
    {
        var xdif = enemy.x - this.x;
        var ydif = enemy.y - this.y;

        return xdif * xdif + ydif * ydif;
    }

    /**
     * Towers won't take damage
     */
    public function takeDamage (e : Entity, d : Float) : Void {}

    public function inflictDamage (e : Entity) : Void
    {
        e.takeDamage (this, this.damage);
    }

    public function addKill () : Void
    {
        this.kills++;
    }


}

package td.entity.tower;

import openfl.display.Sprite;
import openfl.display.Shape;

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
    private static inline var RADIUS = 7.5;

    // Serializable variables
    public var damage : Float;

    public var speed : Float;

    public var rateOfFire : Float;

    public var range : Float;

    public var kills : Int;

    public var level : Int;

    // In-game variables
    public var isSelected : Bool = false;

    public var isHighlighted : Bool = false;

    private var isMoving : Bool = false;

    private var xSpeed : Float = 0;

    private var ySpeed : Float = 0;

    private var xNext : Float;

    private var yNext : Float;

    public var index : Int;

    private var gameStage : GameStage;

    private var highlight : Shape;

    private var rangeIndicator : Shape;

/*
    TODO
    var status:Array<TowerStatus>;

    var items:Array<Item>;
*/

    public function new ()
    {
        super ();
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
        this.rangeIndicator = new Shape ();
        this.rangeIndicator.alpha = 0;
        this.rangeIndicator.graphics.beginFill (0x333333, .5);
        this.rangeIndicator.graphics.drawCircle (0, 0, this.range);
        this.rangeIndicator.graphics.endFill ();

        this.highlight = new Shape ();
        this.highlight.graphics.lineStyle (2, 0xFF0000, .5);
        this.highlight.graphics.drawCircle (0, 0, Tower.RADIUS + 2);
        this.highlight.alpha = 0;
    }

    public function moveTo (x : Float, y : Float) : Void
    {
        if (!this.isSelected) return;

        this.xNext = x;
        this.yNext = y;
        this.isMoving = true;
    }

    public function update () : Void
    {
        this.move ();

        this.highlight.alpha = (this.isHighlighted) ? 1 : 0;
        this.rangeIndicator.alpha = (this.isSelected) ? 1 : 0;
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

        this.highlight.x = this.rangeIndicator.x = this.x;
        this.highlight.y = this.rangeIndicator.y = this.y;
    }

    public function setGameStage (gameStage : GameStage) : Void
    {
        this.gameStage = gameStage;

        this.rangeIndicator.x = this.highlight.x = this.x;
        this.rangeIndicator.y = this.highlight.y = this.y;
        this.gameStage.addTowerEffect (this.rangeIndicator);
        this.gameStage.addTowerEffect (this.highlight);
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

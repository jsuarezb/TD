package td.entity.tower;

import openfl.display.Sprite;
import openfl.display.Shape;

import td.entity.Entity;
import td.entity.Attacker;
import td.entity.enemy.Enemy;
import td.view.components.GameStage;

class Tower extends Sprite implements Entity
{

    // Tower types
    public static inline var BASIC_TOWER : String = "basic_tower";

    public static inline var SPLASH_TOWER : String = "splash_tower";

    public static inline var SNIPER_TOWER : String = "sniper_tower";

    public static inline var PLUS_TOWER : String = "plus_tower";

    public static inline var FREEZE_TOWER : String = "freeze_tower";

    public static inline var POISON_TOWER : String = "poison_tower";

    public static inline var SATELLITE_TOWER : String = "satellite_tower";

    // Tower dimensions
    private static inline var RADIUS = 7.5;

    public var speed : Float;

    public var range : Float;

    public var level : Int;

    // In-game variables
    public var isSelected : Bool = false;

    public var isHighlighted : Bool = false;

    public var isMoving : Bool = false;

    public var xSpeed : Float = 0;

    public var ySpeed : Float = 0;

    public var xNext : Float;

    public var yNext : Float;

    public var index : Int;

    private var gameStage : GameStage;

    public var highlight : Shape;

    public var rangeIndicator : Shape;

    public var chargeIndicator : Shape;

/*
    TODO
    var status:Array<TowerStatus>;

    var items:Array<Item>;
*/

    public function new ()
    {
        super ();

        chargeIndicator = new Shape ();
    }

    public static function create (tower : String, level : Int, kills : Int = 0) : Tower
    {
        switch (tower)
        {
            case Tower.BASIC_TOWER:
                return new BasicTower (level, kills);

            case Tower.SPLASH_TOWER:
                return new SplashTower (level, kills);

            case Tower.SNIPER_TOWER:
                return new SniperTower (level, kills);

            case Tower.PLUS_TOWER:
                return new PlusTower (level, kills);

            case Tower.FREEZE_TOWER:
                return new FreezeTower (level, kills);

            case Tower.POISON_TOWER:
                return new PoisonTower (level, kills);

            case Tower.SATELLITE_TOWER:
                return new SatelliteTower (level);

            default:
                return null;

        }
    }

    public function draw () : Void
    {
        this.rangeIndicator = new Shape ();
        this.rangeIndicator.alpha = 0;
        this.rangeIndicator.graphics.beginFill (0x000000, .25);
        this.rangeIndicator.graphics.drawCircle (0, 0, this.range);
        this.rangeIndicator.graphics.endFill ();

        this.highlight = new Shape ();
        this.highlight.alpha = 0;
        this.highlight.graphics.lineStyle (2, 0x3366FF, .75);
        this.highlight.graphics.drawCircle (0, 0, this.width / 2 + 1);

        this.chargeIndicator = new Shape ();
        this.chargeIndicator.alpha = 0;
        this.chargeIndicator.graphics.beginFill (0x000000, .75);
        this.chargeIndicator.graphics.drawCircle (0, 0, this.width / 2);
        this.chargeIndicator.graphics.endFill ();

        addChild (this.chargeIndicator);
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
        this.hideRange ();
        this.hideHighlight ();

        this.highlight.x = this.rangeIndicator.x = this.x;
        this.highlight.y = this.rangeIndicator.y = this.y;

        if (this.isHighlighted) this.showHighlight ();
        if (this.isSelected) this.showRange ();

        if (hasEnergy ())
        {
            if (this.chargeIndicator.alpha > 0)
                this.chargeIndicator.alpha -= 0.05;
        }
        else
        {
            if (this.chargeIndicator.alpha < 1)
                this.chargeIndicator.alpha += 0.05;
        }
    }

    public function move () : Void
    {
        if (!this.isMoving) return;

        var xDif = this.xNext - this.x;
        var yDif = this.yNext - this.y;
        var dist = Math.sqrt(yDif * yDif + xDif * xDif);

        if (dist <= this.speed)
        {
            this.isMoving = false;

            this.x = this.xNext;
            this.y = this.yNext;
        }
        else
        {
            var angle = Math.atan2(yDif, xDif);

            var xSpeed = Math.cos (angle) * this.speed;
            var ySpeed = Math.sin (angle) * this.speed;
            var hasEnergy = gameStage.getEnergyRange ().isPointInside (
                this.x + xSpeed,
                this.y + ySpeed,
                this
            );

            if (hasEnergy)
            {
                this.x += xSpeed;
                this.y += ySpeed;
            }
            else
            {
                this.isMoving = false;

                this.xNext = this.x;
                this.yNext = this.y;
            }
        }
    }

    public function getGameStage () : GameStage
    {
        return this.gameStage;
    }

    public function setGameStage (gameStage : GameStage) : Void
    {
        this.gameStage = gameStage;

        this.rangeIndicator.x = this.highlight.x = this.x;
        this.rangeIndicator.y = this.highlight.y = this.y;
        this.gameStage.addTowerEffect (this.rangeIndicator);
        this.gameStage.addTowerEffect (this.highlight);
    }

    public function sqrDistanceTo (entity : Sprite) : Float
    {
        var xdif = entity.x - this.x;
        var ydif = entity.y - this.y;

        return xdif * xdif + ydif * ydif;
    }

    public function isSatellite () : Bool
    {
        return false;
    }

    public function hasEnergy () : Bool
    {
        return gameStage.getEnergyRange ().isPointInside (
            this.x,
            this.y,
            this
        );
    }

    public function showRange () : Void
    {
        this.rangeIndicator.alpha = 1;
    }

    public function hideRange () : Void
    {
        this.rangeIndicator.alpha = 0;
    }

    public function showHighlight () : Void
    {
        this.highlight.alpha = 1;
    }

    public function hideHighlight () : Void
    {
        this.highlight.alpha = 0;
    }

    public function pause () : Void {}

    public function resume () : Void {}

    /**
     * Towers won't take damage
     */
    public function takeDamage (e : Entity, d : Float) : Void {}

    public function destroy () : Void {}

}

package td.entity.enemy;

import openfl.display.Sprite;
import openfl.events.Event;

import td.entity.Entity;
import td.event.EnemyEvent;
import td.view.components.GameStage;
import td.util.effects.IEffect;
import td.util.effects.EnemyEffect;
import td.util.effects.EffectsCollection;

class Enemy extends Sprite implements Attacker
{

    public static inline var LEFT_STAGE : Int = 0;

    public static inline var TOP_STAGE : Int = 1;

    public static inline var RIGHT_STAGE : Int = 2;

    public static inline var BOTTOM_STAGE : Int = 3;

    public static inline var SIMPLE_ENEMY : String = "simple_enemy";

    public static inline var SPIRAL_ENEMY : String = "spiral_enemy";

    public static inline var DISTANCE_ENEMY : String = "distance_enemy";

    public static inline var FAT_ENEMY : String = "fat_enemy";

    public var level : Int;

    public var hp : Float;

    public var damage : Float;

    public var rateOfFire : Float;

    public var speed : Float;

    public var range : Float;

    public var defense : Float;

    public var value : Int;

    public var zones : Array<Int>;

    public var gameStage (null, default): GameStage;

    public var index : Int;

    public var effects : EffectsCollection = new EffectsCollection ();

    public function new (level : Dynamic, zones : Array<Int>)
    {
        super ();

        this.mouseEnabled = false;

        this.level = level;
        this.zones = zones;

        addEventListener (Event.ADDED_TO_STAGE, onAddedToStage);
    }

    /**
     * Creation of enemy
     */
    public static function create (enemy : String, level : Dynamic, zones : Array<Int>) : Enemy
    {
        var level = Std.int (Math.random () * (level.max - level.min) + level.min);

        switch ( enemy ) {
            case Enemy.SIMPLE_ENEMY:
                return new SimpleEnemy (level, zones);

            case Enemy.SPIRAL_ENEMY:
                return new SpiralEnemy (level, zones);

            case Enemy.DISTANCE_ENEMY:
                return new DistanceEnemy (level, zones);

            case Enemy.FAT_ENEMY:
                return new FatEnemy (level, zones);

            default:
                return null;
        }

    }

    /**
     * Stores the `gameStage` sprite that contains this Enemy instance
     */
    public function setGameStage (gameStage : GameStage) : Void
    {
        this.gameStage = gameStage;
    }

    public function addEffect (e : EnemyEffect) : Void
    {
        this.effects.add (e);
    }

    public function update () : Void
    {
        this.effects.apply (EffectType.HP);

        this.move ();
    }

    /**
     * Movement function to use every frame
     * To be overriden by implementation
     */
    public function move () : Void {}

    /**
     * Notify listeners that enemy has died
     */
    public function die () : Void
    {
        dispatchEvent (new EnemyEvent(EnemyEvent.DEAD, this));
    }

    public function onAddedToStage (e : Event) : Void
    {
        removeEventListener (Event.ADDED_TO_STAGE, onAddedToStage);

        var l = zones.length;
        var i = Std.int (Math.random () * l);

        switch ( zones[i] ) {
            case Enemy.LEFT_STAGE:
                this.x = -this.width;
                this.y = Math.random () * this.gameStage._height;

            case Enemy.TOP_STAGE:
                this.x = Math.random () * this.gameStage._width;
                this.y = -this.height;

            case Enemy.RIGHT_STAGE:
                this.x = this.gameStage._width + this.width;
                this.y = Math.random () * this.gameStage._height;

            case Enemy.BOTTOM_STAGE:
                this.x = Math.random () * this.gameStage._width;
                this.y = this.gameStage._height + this.height;

            default:
                throw "Invalid zone";
        }

    }

    public function takeDamage (attacker : Attacker, d : Float) : Void {
        this.hp -= d;

        if (this.hp <= 0) {
            attacker.addKill ();
            die ();
        }
    }

    public function getScore () : Int
    {
        /* TODO specify value for every enemy based on level */
        return 12;
    }


    public function inflictDamage (e : Entity) : Void {}

    public function addKill () : Void {}

}

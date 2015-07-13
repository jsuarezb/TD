package td.entity.enemy;

import openfl.display.Sprite;
import openfl.events.Event;

import td.event.EnemyEvent;
import td.util.GameStage;
import td.entity.Entity;

class Enemy extends Sprite implements Entity
{

    public static inline var LEFT_STAGE : Int = 0;

    public static inline var TOP_STAGE : Int = 1;

    public static inline var RIGHT_STAGE : Int = 2;

    public static inline var BOTTOM_STAGE : Int = 3;

    public static inline var SIMPLE_ENEMY : String = "simple_enemy";

    public var level : Int;

    public var hp : Float;

    public var damage : Float;

    public var rateOfFire : Float;

    public var range : Float;

    public var defense : Float;

    public var value : Int;

    public var zones : Array<Int>;

    public var gameStage (null, default): GameStage;

    public var index : Int;

    public function new (level : Dynamic, zones : Array<Int>)
    {
        super ();

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

            default:
                return null;
        }

    }

    /**
     * Stores the `gameStage` sprite that contains this Enemy instance
     */
    public function setContainer (gameStage : GameStage) : Void
    {
        this.gameStage = gameStage;
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

    public function onAddedToStage (e:Event) : Void
    {
        removeEventListener (Event.ADDED_TO_STAGE, onAddedToStage);

        var l = zones.length;
        var i = Std.int (Math.random () * l);

        switch ( i ) {
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

    public function takeDamage (e : Entity, d : Float) : Void {}

    public function inflictDamage (e : Entity) : Void {}


}

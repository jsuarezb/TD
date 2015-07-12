package td.entity;

import openfl.display.Sprite;
import openfl.events.Event;

import td.util.EnemyData;
import td.util.GameStage;
import td.entity.enemy.*;

class Enemy extends Sprite
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

    public var container (null, default): GameStage;

    public function new ()
    {
        super ();

        this.graphics.beginFill(0x000000);
        this.graphics.drawRect(0, 0, 10, 10);

        addEventListener (Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public static function create (enemy : EnemyData) : Enemy
    {
        var level = Std.int (
            Math.random () * (enemy.level.max - enemy.level.min) + enemy.level.min
        );

        switch ( enemy.enemyType ) {
            case Enemy.SIMPLE_ENEMY:
                return new SimpleEnemy (level, enemy.zones);
        }

        return null;
    }

    /**
     * Movement function to use every frame
     * To be overriden by implementation
     */
    public function move () : Void {}


    public function inflictDamage () : Void
    {

    }

    public function takeDamage (damage : Float) : Void
    {

    }

    public function onAddedToStage (e:Event) : Void
    {
        removeEventListener (Event.ADDED_TO_STAGE, onAddedToStage);

        var l = zones.length;
        var i = Std.int (Math.random () * l);

        switch ( i ) {
            case Enemy.LEFT_STAGE:
                this.x = -this.width;
                this.y = Math.random () * this.container._height;

            case Enemy.TOP_STAGE:

            case Enemy.RIGHT_STAGE:

            case Enemy.BOTTOM_STAGE:

            default:

        }

    }


}

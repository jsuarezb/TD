package td.entity.tower;

import td.util.*;

class SimpleTower extends Tower
{

    public static inline var BASE_DAMAGE : Float = 10;

    public static inline var BASE_SPEED : Float = 0.5;

    public static inline var BASE_RATE_OF_FIRE : Float = 10;

    public static inline var BASE_RANGE : Float = 10;

    public function new (level : Int, kills : Int)
    {
        super ();

        this.damage = SimpleTower.BASE_DAMAGE + level * 0.2;
        this.speed = SimpleTower.BASE_SPEED + level * 0.1;
        this.range = SimpleTower.BASE_RANGE + level * 10;
        this.rateOfFire = SimpleTower.BASE_RATE_OF_FIRE - level;
        this.kills = kills;
        this.level = level;
    }

    override public function draw () : Void
    {
        super.draw ();

        this.graphics.beginFill (0);
        this.graphics.drawCircle (7.5, 7.5, 2.5);
    }

}

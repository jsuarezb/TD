package td.entity.enemy;

import td.entity.Enemy;

class SimpleEnemy extends Enemy
{

    public static inline var BASE_HP : Int = 10;

    public static inline var BASE_DAMAGE : Int = 10;

    public static inline var BASE_RATE_OF_FIRE : Float = 10;

    public static inline var BASE_RANGE : Float = 10;

    public static inline var BASE_DEFENSE : Float = 10;

    public static inline var BASE_VALUE : Int = 10;

    public function new (level : Int, zones : Array<Int>)
    {
        super ();

        this.level = level;
        this.zones = zones;

        this.hp = SimpleEnemy.BASE_HP * level;
        this.damage = SimpleEnemy.BASE_DAMAGE * level;
        this.rateOfFire = SimpleEnemy.BASE_RATE_OF_FIRE * level;
        this.range = SimpleEnemy.BASE_RANGE * level;
        this.defense = SimpleEnemy.BASE_DEFENSE * level;
        this.value = SimpleEnemy.BASE_VALUE * level;
    }

    override public function move () : Void
    {
        this.x += 10;

        trace ("Hi");
    }

}

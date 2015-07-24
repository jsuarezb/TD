package td.entity.enemy;

import td.util.effects.IEffect;

class SpiralEnemy extends Enemy
{

    public static inline var BASE_HP : Int = 25;

    public static inline var BASE_DAMAGE : Int = 10;

    public static inline var BASE_RATE_OF_FIRE : Float = 10;

    public static inline var BASE_RANGE : Float = 10;

    public static inline var BASE_DEFENSE : Float = 10;

    public static inline var BASE_VALUE : Int = 10;

    private static inline var PARTICLES : Int = 2;

    private var radius : Int = 5;

    public function new (level : Int, zones : Array<Int>)
    {
        super (level, zones);

        this.graphics.beginFill (0x000000, .6);
        this.graphics.drawCircle (0, 0, this.radius);
        this.graphics.endFill ();

        this.graphics.beginFill (0x6060C0);
        this.graphics.drawCircle (0, 0, this.radius / 2);
        this.graphics.endFill ();

        this.hp = SimpleEnemy.BASE_HP * level;
        this.damage = SimpleEnemy.BASE_DAMAGE * level;
        this.rateOfFire = SimpleEnemy.BASE_RATE_OF_FIRE * level;
        this.range = SimpleEnemy.BASE_RANGE * level;
        this.defense = SimpleEnemy.BASE_DEFENSE * level;
        this.value = SimpleEnemy.BASE_VALUE * level;
        this.speed = 1;
    }

    override public function move () : Void
    {
        var base = this.gameStage.getBase ();
        var xdif = this.x - base.x;
        var ydif = this.y - base.y;
        var dist = xdif * xdif + ydif * ydif;

        if (dist < this.radius * this.radius) {
            inflictDamage (this.gameStage.getBase());
            die ();
        } else {
            this.effects.apply (EffectType.SPEED);

            var angle = Math.atan2(ydif, xdif) + (speed / 100);
            dist = Math.sqrt (dist);
            this.x = base.x + (dist - speed) * Math.cos (angle);
            this.y = base.y + (dist - speed) * Math.sin (angle);
        }
    }

    override public function inflictDamage (e : Entity) : Void
    {
        e.takeDamage (this, this.damage);
    }

    override public function getParticles () : Int
    {
        return Std.int (super.getParticles () + SpiralEnemy.PARTICLES * this.level / 2);
    }

}

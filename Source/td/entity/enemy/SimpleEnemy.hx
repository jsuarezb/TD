package td.entity.enemy;

import td.util.effects.IEffect;

class SimpleEnemy extends Enemy
{

    public static inline var BASE_HP : Int = 25;

    public static inline var BASE_DAMAGE : Int = 10;

    public static inline var BASE_RATE_OF_FIRE : Float = 10;

    public static inline var BASE_RANGE : Float = 10;

    public static inline var BASE_DEFENSE : Float = 10;

    public static inline var BASE_VALUE : Int = 10;

    private var radius : Int = 5;

    public function new (level : Int, zones : Array<Int>)
    {
        super (level, zones);

        this.graphics.beginFill (0x000000, .6);
        this.graphics.drawCircle (0, 0, this.radius);
        this.graphics.endFill ();

        this.graphics.beginFill (0xC06060);
        this.graphics.drawCircle (0, 0, this.radius / 2);
        this.graphics.endFill ();

        this.hp = SimpleEnemy.BASE_HP * level;
        this.damage = SimpleEnemy.BASE_DAMAGE * level;
        this.rateOfFire = SimpleEnemy.BASE_RATE_OF_FIRE * level;
        this.range = SimpleEnemy.BASE_RANGE * level;
        this.speed = 1;
        this.defense = SimpleEnemy.BASE_DEFENSE * level;
        this.value = SimpleEnemy.BASE_VALUE * level;
    }

    override public function move () : Void
    {
        var base = this.gameStage.getBase ();
        var xdif = base.x - this.x;
        var ydif = base.y - this.y;
        var dist = xdif * xdif + ydif * ydif;

        if (dist < this.radius * this.radius) {
            inflictDamage (this.gameStage.getBase());
            die ();
        } else {
            var angle = Math.atan2(ydif, xdif);

            this.effects.apply (EffectType.SPEED);
            this.x += this.speed * Math.cos (angle);
            this.y += this.speed * Math.sin (angle);
        }
    }

    override public function inflictDamage (e : Entity) : Void
    {
        e.takeDamage (this, this.damage);
    }

}

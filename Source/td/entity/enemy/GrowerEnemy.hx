package td.entity.enemy;

import td.util.effects.IEffect;

class GrowerEnemy extends Enemy
{

    private static inline var BASE_HP : Int = 10;

    private static inline var BASE_DAMAGE : Int = 10;

    private static inline var BASE_RATE_OF_FIRE : Float = 10;

    private static inline var BASE_RANGE : Float = 10;

    private static inline var BASE_DEFENSE : Float = 10;

    private static inline var BASE_VALUE : Int = 10;

    private static inline var BASE_HP_REGEN: Float = 0.1;

    private static inline var MIN_RADIUS : Int = 5;

    private static inline var MAX_RADIUS : Int = 10;

    private static inline var HEALTH_CONSTANT : Int = 30;

    private static inline var PARTICLES : Int = 2;

    private var radius : Float;

    private var hpRegen : Float;

    public function new (level : Int, zones : Array<Int>)
    {
        super (level, zones);

        this.hp = GrowerEnemy.BASE_HP;
        this.damage = GrowerEnemy.BASE_DAMAGE * level;
        this.rateOfFire = GrowerEnemy.BASE_RATE_OF_FIRE * level;
        this.range = GrowerEnemy.BASE_RANGE * level;
        this.defense = GrowerEnemy.BASE_DEFENSE * level;
        this.value = GrowerEnemy.BASE_VALUE * level;
        this.hpRegen = GrowerEnemy.BASE_HP_REGEN * level;
        this.radius = GrowerEnemy.MIN_RADIUS;
        this.speed = 1;
    }

    private function draw () : Void
    {
        this.graphics.clear ();

        this.graphics.beginFill (0x000000, .6);
        this.graphics.drawCircle (0, 0, this.radius);
        this.graphics.endFill ();

        this.graphics.beginFill (0x90EEBF);
        this.graphics.drawCircle (0, 0, this.radius / 2);
        this.graphics.endFill ();
    }

    override public function move () : Void
    {
        var base = this.gameStage.getBase ();
        var xdif = base.x - this.x;
        var ydif = base.y - this.y;

        baseDistance = Math.sqrt (xdif * xdif + ydif * ydif);

        hp += hpRegen;
        hp = (hp <= this.level * HEALTH_CONSTANT) ? hp : this.level * HEALTH_CONSTANT;
        radius = hp  / (this.level * HEALTH_CONSTANT) * (MAX_RADIUS - MIN_RADIUS) + MIN_RADIUS;
        draw ();

        if (baseDistance < radius) {
            inflictDamage (gameStage.getBase());
            die ();
        } else {
            var angle = Math.atan2(ydif, xdif);

            effects.apply (EffectType.SPEED);
            x += speed * Math.cos (angle);
            y += speed * Math.sin (angle);
        }
    }

    override public function inflictDamage (e : Entity) : Void
    {
        e.takeDamage (this, this.damage);
    }

    override public function getParticles () : Int
    {
        return Std.int (super.getParticles () + GrowerEnemy.PARTICLES * this.level / 2);
    }

}

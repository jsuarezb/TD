package td.entity.enemy;

import td.util.effects.IEffect;

class DistanceEnemy extends Enemy
{

    public static inline var BASE_HP : Int = 25;

    public static inline var BASE_DAMAGE : Int = 10;

    public static inline var BASE_RATE_OF_FIRE : Float = 10;

    public static inline var BASE_RANGE : Float = 10;

    public static inline var BASE_DEFENSE : Float = 10;

    public static inline var BASE_VALUE : Int = 10;

    private static inline var DISTANCE_THRESHOLD : Float = 250;

    private static inline var WAIT_THRESHOLD : Int = 30;

    private static inline var PARTICLES : Int = 2;

    private var radius : Int = 5;

    private var friction : Float = 0.8;

    private var acceleration : Float = 2;

    private var waitReached : Bool = false;

    private var waitCounter : Int = 0;

    public function new (level : Int, zones : Array<Int>)
    {
        super (level, zones);

        this.graphics.beginFill (0x000000, .6);
        this.graphics.drawCircle (0, 0, this.radius);
        this.graphics.endFill ();

        this.graphics.beginFill (0xFFFFFF);
        this.graphics.drawCircle (0, 0, this.radius / 2);
        this.graphics.endFill ();

        this.hp = DistanceEnemy.BASE_HP * level;
        this.damage = DistanceEnemy.BASE_DAMAGE * level;
        this.rateOfFire = DistanceEnemy.BASE_RATE_OF_FIRE * level;
        this.range = DistanceEnemy.BASE_RANGE * level;
        this.defense = DistanceEnemy.BASE_DEFENSE * level;
        this.value = DistanceEnemy.BASE_VALUE * level;
        this.speed = 0.5;
    }

    override public function move () : Void
    {
        var base = this.gameStage.getBase ();
        var xdif = base.x - this.x;
        var ydif = base.y - this.y;

        baseDistance = Math.sqrt (xdif * xdif + ydif * ydif);

        if (waitReached)
        {
            if (waitCounter < WAIT_THRESHOLD)
            {
                this.speed *= this.friction;
                effects.apply (EffectType.SPEED);
                waitCounter++;
            }
            else
            {
                var angle = Math.atan2 (ydif, xdif);
                var firstDif = {
                    x: this.x - base.x,
                    y: this.y - base.y
                };

                this.speed += this.acceleration;
                effects.apply (EffectType.SPEED);
                this.x += speed * Math.cos (angle);
                this.y += speed * Math.sin (angle);

                var secDif = {
                    x: this.x - base.x,
                    y: this.y - base.y
                };

                /* TODO handle division by 0 */
                if (firstDif.x / secDif.x <= 0 || firstDif.y / secDif.y <= 0)
                {
                    this.x = base.x;
                    this.y = base.y;

                    inflictDamage (this.gameStage.getBase());
                    die ();
                }
            }
        }
        else
        {
            var angle = Math.atan2(ydif, xdif);

            if (baseDistance <= DISTANCE_THRESHOLD)
                waitReached = true;

            effects.apply (EffectType.SPEED);
            this.x += speed * Math.cos (angle);
            this.y += speed * Math.sin (angle);
        }
    }

    override public function inflictDamage (e : Entity) : Void
    {
        e.takeDamage (this, this.damage);
    }

    override public function getParticles () : Int
    {
        return Std.int (super.getParticles () + DistanceEnemy.PARTICLES * this.level / 2);
    }

}

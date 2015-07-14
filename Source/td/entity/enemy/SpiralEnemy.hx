package td.entity.enemy;

class SpiralEnemy extends Enemy
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

        this.graphics.beginFill(0x000000);
        this.graphics.drawCircle(0, 0, this.radius);

        this.hp = SimpleEnemy.BASE_HP * level;
        this.damage = SimpleEnemy.BASE_DAMAGE * level;
        this.rateOfFire = SimpleEnemy.BASE_RATE_OF_FIRE * level;
        this.range = SimpleEnemy.BASE_RANGE * level;
        this.defense = SimpleEnemy.BASE_DEFENSE * level;
        this.value = SimpleEnemy.BASE_VALUE * level;
    }

    override public function move () : Void
    {
        var base = this.gameStage.getBase ();
        var xdif = this.x - base.x;
        var ydif = this.y - base.y;
        var dist = xdif * xdif + ydif * ydif;

        var speed = 1;

        if (dist < this.radius * this.radius) {
            inflictDamage (this.gameStage.getBase());
            die ();
        } else {
            var angle = Math.atan2(ydif, xdif) + 0.01;
            var angularSpeed = 0.01;

            dist = Math.sqrt (dist);
            this.x = base.x + (dist - speed) * Math.cos (angle);
            this.y = base.y + (dist - speed) * Math.sin (angle);
        }
    }

    override public function inflictDamage (e : Entity) : Void
    {
        e.takeDamage (this, this.damage);
    }

}

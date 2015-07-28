package td.entity.towers;

import openfl.display.Shape;
import openfl.utils.Timer;
import openfl.events.TimerEvent;

import td.entity.enemy.Enemy;
import td.util.effects.PoisonEffect;

class PoisonTower extends LaserAttackTower
{

    private static inline var NAME : String = "Poison";

    public static inline var BASE_SPEED : Float = 0.5;

    public static inline var BASE_RANGE : Float = 100;

    public static inline var BASE_POISON_DAMAGE : Float = 0.1;

    public static inline var BASE_RATE_OF_FIRE : Float = 750;

    private var poisonDamage : Float;

    public function new (level : Int, kills : Int)
    {
        super ();

        this.poisonDamage = BASE_POISON_DAMAGE + level * 0.1;
        this.speed = BASE_SPEED + level * 0.1;
        this.range = BASE_RANGE + level * 5;
        this.rateOfFire = BASE_RATE_OF_FIRE - level * 30;
        this.kills = kills;
        this.level = level;

        this.timer = new Timer (this.rateOfFire);
        this.timer.addEventListener (TimerEvent.TIMER, shoot);
        this.timer.start ();

        draw ();
    }

    override public function getName () : String
    {
        return NAME;
    }

    override public function draw () : Void
    {
        graphics.beginFill (0xFFFFFF);
        graphics.drawCircle (0, 0, Tower.RADIUS);
        graphics.endFill ();

        graphics.beginFill (0x60E060);
        graphics.drawCircle (0, 0, Tower.RADIUS / 2);
        graphics.endFill ();

        super.draw ();
    }

    override public function attack (enemy : Enemy) : Void
    {
        drawLaser (enemy);
        enemy.addEffect (new PoisonEffect (100, enemy, poisonDamage, this));
    }

    override private function drawLaser (enemy : Enemy) : Void
    {
        var laser = new Shape ();

        laser.graphics.lineStyle (1, 0x60E060);
        laser.graphics.moveTo (x, y);
        laser.graphics.lineTo (enemy.x, enemy.y);

        gameStage.addChild (laser);
        lasers.push (laser);
    }


}

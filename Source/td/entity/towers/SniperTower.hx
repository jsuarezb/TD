package td.entity.towers;

import openfl.display.Shape;
import openfl.utils.Timer;
import openfl.events.TimerEvent;

import td.entity.enemy.Enemy;

class SniperTower extends LaserAttackTower
{

    private static inline var NAME : String = "Sniper";

    public static inline var BASE_DAMAGE : Float = 100;

    public static inline var BASE_SPEED : Float = 0.5;

    public static inline var BASE_RATE_OF_FIRE : Float = 4000;

    public static inline var BASE_RANGE : Float = 1000;

    public function new (level : Int, kills : Int)
    {
        super ();

        this.damage = BASE_DAMAGE + level * 0.2;
        this.speed = BASE_SPEED + level * 0.1;
        this.range = BASE_RANGE + level * 10;
        this.rateOfFire = BASE_RATE_OF_FIRE;
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

        graphics.beginFill (0xFF3030);
        graphics.drawCircle (0, 0, Tower.RADIUS / 2);
        graphics.endFill ();

        super.draw ();
    }

    override public function attack (enemy : Enemy) : Void
    {
        drawLaser (enemy);
        inflictDamage (enemy);
    }

    override public function drawLaser (enemy : Enemy) : Void
    {
        var laser = new Shape ();

        laser.graphics.lineStyle (1, 0xFF3030);
        laser.graphics.moveTo (x, y);
        laser.graphics.lineTo (enemy.x, enemy.y);

        gameStage.addChild (laser);
        lasers.push (laser);
    }

}

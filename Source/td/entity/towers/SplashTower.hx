package td.entity.towers;

import openfl.display.Shape;
import openfl.utils.Timer;
import openfl.events.TimerEvent;

import td.entity.enemy.Enemy;

class SplashTower extends SplashAttackTower
{

    private static inline var NAME : String = "Area";

    public static inline var BASE_DAMAGE : Float = 10;

    public static inline var BASE_SPEED : Float = 0.5;

    public static inline var BASE_RATE_OF_FIRE : Float = 2000;

    public static inline var BASE_RANGE : Float = 100;

    public function new (level : Int, kills : Int)
    {
        super ();

        this.damage = SplashTower.BASE_DAMAGE + level * 0.2;
        this.speed = SplashTower.BASE_SPEED + level * 0.1;
        this.range = SplashTower.BASE_RANGE + level * 2;
        this.rateOfFire = SplashTower.BASE_RATE_OF_FIRE - level * 5;
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
        this.graphics.beginFill (0xFFFFFF);
        this.graphics.drawCircle (0, 0, Tower.RADIUS);
        this.graphics.endFill ();

        this.graphics.beginFill (0xAA4B90);
        this.graphics.drawCircle (0, 0, Tower.RADIUS / 2);
        this.graphics.endFill ();

        super.draw ();
    }

    override public function attack (enemy : Enemy) : Void
    {
        inflictDamage (enemy);
    }

    override private function drawSplash () : Void
    {
        var splash = new Shape ();

        splash.graphics.beginFill (0xFFFFFF);
        splash.graphics.drawCircle (x, y, range);
        splash.alpha = 0.5;

        gameStage.addChild (splash);
        splashes.push (splash);
    }

}

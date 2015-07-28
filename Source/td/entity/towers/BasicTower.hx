package td.entity.towers;

import openfl.display.Shape;
import openfl.utils.Timer;
import openfl.events.TimerEvent;

import td.entity.enemy.Enemy;
import td.util.*;

class BasicTower extends LaserAttackTower
{

    private static inline var TOWER_NAME : String = "Basic";

    public static inline var BASE_SPEED : Float = 0.5;

    public static inline var BASE_RANGE : Float = 100;

    public static inline var BASE_DAMAGE : Float = 30;

    public static inline var BASE_RATE_OF_FIRE : Float = 750;

    public function new (level : Int, kills : Int)
    {
        super ();

        this.damage = BASE_DAMAGE + level * 0.2;
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
        return TOWER_NAME;
    }

    override public function draw () : Void
    {
        this.graphics.beginFill (0xFFFFFF);
        this.graphics.drawCircle (0, 0, Tower.RADIUS);
        this.graphics.endFill ();

        this.graphics.beginFill (0x909090);
        this.graphics.drawCircle (0, 0, Tower.RADIUS / 2);
        this.graphics.endFill ();

        super.draw ();
    }

    override public function attack (enemy : Enemy) : Void
    {
        drawLaser (enemy);
        inflictDamage (enemy);
    }

    override private function drawLaser (enemy : Enemy) : Void
    {
        var laser = new Shape ();

        laser.graphics.lineStyle (1, 0xE0E0E0);
        laser.graphics.moveTo (x, y);
        laser.graphics.lineTo (enemy.x, enemy.y);

        gameStage.addChild (laser);
        lasers.push (laser);
    }

}

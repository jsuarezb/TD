package td.entity.towers;

import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.utils.Timer;
import openfl.events.TimerEvent;

import td.entity.enemy.Enemy;
import td.util.*;

class PlusTower extends LaserAttackTower
{

    private static inline var NAME : String = "Plus";

    public static inline var BASE_SPEED : Float = 0.5;

    public static inline var BASE_RANGE : Float = 200;

    public static inline var BASE_DAMAGE : Float = 30;

    public static inline var BASE_RATE_OF_FIRE : Float = 750;

    private var minWidth : Float;

    private var minHeight : Float;

    private var maxWidth : Float;

    private var maxHeight : Float;

    public function new (level : Int, kills : Int)
    {
        super ();

        this.damage = BasicTower.BASE_DAMAGE + level * 0.2;
        this.speed = BasicTower.BASE_SPEED + level * 0.1;
        this.range = BasicTower.BASE_RANGE + level * 5;
        this.rateOfFire = BasicTower.BASE_RATE_OF_FIRE - level * 30;
        this.kills = kills;
        this.level = level;
        this.minWidth = this.minHeight = 20;
        this.maxWidth = this.maxHeight = 200;

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

        graphics.beginFill (0xE0E060);
        graphics.drawCircle (0, 0, Tower.RADIUS / 2);
        graphics.endFill ();

        super.draw ();

        // Clear the range draw by default and draw special range
        rangeIndicator.graphics.clear ();
        rangeIndicator.graphics.beginFill (0x000000, .25);
        rangeIndicator.graphics.moveTo (-maxWidth, -minHeight);
        rangeIndicator.graphics.lineTo (-minWidth, -minHeight);
        rangeIndicator.graphics.lineTo (-minWidth, -maxHeight);
        rangeIndicator.graphics.lineTo (minWidth, -maxHeight);
        rangeIndicator.graphics.lineTo (minWidth, -minHeight);
        rangeIndicator.graphics.lineTo (maxWidth, -minHeight);
        rangeIndicator.graphics.lineTo (maxWidth, minHeight);
        rangeIndicator.graphics.lineTo (minWidth, minHeight);
        rangeIndicator.graphics.lineTo (minWidth, maxHeight);
        rangeIndicator.graphics.lineTo (-minWidth, maxHeight);
        rangeIndicator.graphics.lineTo (-minWidth, minHeight);
        rangeIndicator.graphics.lineTo (-maxWidth, minHeight);
        rangeIndicator.graphics.lineTo (-maxWidth, -minHeight);
        rangeIndicator.graphics.endFill ();
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

    override public function inRange (sprite : Sprite) : Bool
    {
        var xDif = sprite.x - x;
        var yDif = sprite.y - y;

        if (Math.abs (xDif) < minWidth && Math.abs (yDif) < maxHeight)
            return true;

        if (Math.abs (xDif) < maxWidth && Math.abs (yDif) < minHeight)
            return true;

        return false;
    }

}

package td.entity.tower;

import openfl.display.Shape;
import openfl.utils.Timer;
import openfl.events.TimerEvent;

import td.entity.enemy.Enemy;
import td.util.*;

class PlusTower extends AttackTower
{

    public static inline var BASE_SPEED : Float = 0.5;

    public static inline var BASE_RANGE : Float = 200;

    public static inline var BASE_DAMAGE : Float = 30;

    public static inline var BASE_RATE_OF_FIRE : Float = 750;

    private var lasers : Array<Shape>;

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
        this.maxWidth = this.maxHeight = 100;
        this.lasers = new Array<Shape> ();

        this.timer = new Timer (this.rateOfFire);
        this.timer.addEventListener (TimerEvent.TIMER, shoot);
        this.timer.start ();

        draw ();
    }

    override public function draw () : Void
    {
        this.graphics.beginFill (0xFFFFFF);
        this.graphics.drawCircle (0, 0, Tower.RADIUS);
        this.graphics.endFill ();

        this.graphics.beginFill (0xE0E060);
        this.graphics.drawCircle (0, 0, Tower.RADIUS / 2);
        this.graphics.endFill ();

        super.draw ();

        this.rangeIndicator.graphics.clear ();
        this.rangeIndicator.graphics.beginFill (0x000000, .25);
        this.rangeIndicator.graphics.moveTo (-maxWidth, -minHeight);
        this.rangeIndicator.graphics.lineTo (-minWidth, -minHeight);
        this.rangeIndicator.graphics.lineTo (-minWidth, -maxHeight);
        this.rangeIndicator.graphics.lineTo (minWidth, -maxHeight);
        this.rangeIndicator.graphics.lineTo (minWidth, -minHeight);
        this.rangeIndicator.graphics.lineTo (maxWidth, -minHeight);
        this.rangeIndicator.graphics.lineTo (maxWidth, minHeight);
        this.rangeIndicator.graphics.lineTo (minWidth, minHeight);
        this.rangeIndicator.graphics.lineTo (minWidth, maxHeight);
        this.rangeIndicator.graphics.lineTo (-minWidth, maxHeight);
        this.rangeIndicator.graphics.lineTo (-minWidth, minHeight);
        this.rangeIndicator.graphics.lineTo (-maxWidth, minHeight);
        this.rangeIndicator.graphics.lineTo (-maxWidth, -minHeight);
        this.rangeIndicator.graphics.endFill ();
    }

    override public function shoot (e : TimerEvent) : Void
    {
        if (!hasEnergy ())
            return;

        var enemies = this.gameStage.getEnemies ();

        var target : Enemy = null;
        for (enemy in enemies)
        {
            if (isInsideRange (enemy))
            {
                target = enemy;
            }
        }

        if (target != null) {
            drawLaser (target);
            inflictDamage (target);
        }
    }

    override public function update () : Void
    {
        super.update ();

        for (l in lasers)
        {
            if (l.alpha <= 0) {
                this.gameStage.removeChild (l);
                this.lasers.remove (l);
            }

            l.alpha -= 0.1;
        }
    }

    private function drawLaser (enemy : Enemy) : Void
    {
        var laser = new Shape ();

        laser.graphics.lineStyle (1, 0xE0E0E0);
        laser.graphics.moveTo (this.x, this.y);
        laser.graphics.lineTo (enemy.x, enemy.y);

        this.gameStage.addChild (laser);
        this.lasers.push (laser);
    }

    private function isInsideRange (target : Enemy) : Bool
    {
        var xDif = target.x - this.x;
        var yDif = target.y - this.y;

        if (Math.abs (xDif) < minWidth && Math.abs (yDif) < maxHeight)
            return true;

        if (Math.abs (xDif) < maxWidth && Math.abs (yDif) < minHeight)
            return true;

        return false;
    }

}

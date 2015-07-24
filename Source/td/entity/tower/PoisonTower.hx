package td.entity.tower;

import openfl.display.Shape;
import openfl.utils.Timer;
import openfl.events.TimerEvent;

import td.entity.enemy.Enemy;
import td.util.effects.PoisonEffect;

class PoisonTower extends AttackTower
{

    public static inline var BASE_SPEED : Float = 0.5;

    public static inline var BASE_RANGE : Float = 100;

    public static inline var BASE_POISON_DAMAGE : Float = 0.1;

    public static inline var BASE_RATE_OF_FIRE : Float = 750;

    private var poisonDamage : Float;

    private var lasers : Array<Shape>;

    public function new (level : Int, kills : Int)
    {
        super ();

        this.poisonDamage = PoisonTower.BASE_POISON_DAMAGE + level * 0.1;
        this.speed = PoisonTower.BASE_SPEED + level * 0.1;
        this.range = PoisonTower.BASE_RANGE + level * 5;
        this.rateOfFire = PoisonTower.BASE_RATE_OF_FIRE - level * 30;
        this.kills = kills;
        this.level = level;
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

        this.graphics.beginFill (0x60E060);
        this.graphics.drawCircle (0, 0, Tower.RADIUS / 2);
        this.graphics.endFill ();

        super.draw ();
    }

    override public function shoot (e : TimerEvent) : Void
    {
        if (!hasEnergy ())
            return;

        var enemies = this.gameStage.getEnemies ();

        var target : Enemy = null;
        var minDist = this.range;
        for (enemy in enemies)
        {
            var d = sqrDistanceTo (enemy);

            if (d <= minDist * minDist)
            {
                target = enemy;
                minDist = Math.sqrt (d);
            }
        }

        if (target != null) {
            drawLaser (target);
            target.addEffect (new PoisonEffect (100, target, this.poisonDamage, this));
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

        laser.graphics.lineStyle (1, 0x60E060);
        laser.graphics.moveTo (this.x, this.y);
        laser.graphics.lineTo (enemy.x, enemy.y);

        this.gameStage.addChild (laser);
        this.lasers.push (laser);
    }


}

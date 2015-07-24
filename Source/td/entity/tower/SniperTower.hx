package td.entity.tower;

import openfl.display.Shape;
import openfl.utils.Timer;
import openfl.events.TimerEvent;

import td.entity.enemy.Enemy;

class SniperTower extends AttackTower
{

        public static inline var BASE_DAMAGE : Float = 100;

        public static inline var BASE_SPEED : Float = 0.5;

        public static inline var BASE_RATE_OF_FIRE : Float = 4000;

        public static inline var BASE_RANGE : Float = 1000;

        private var lasers : Array<Shape>;

        public function new (level : Int, kills : Int)
        {
            super ();

            this.damage = SniperTower.BASE_DAMAGE + level * 0.2;
            this.speed = SniperTower.BASE_SPEED + level * 0.1;
            this.range = SniperTower.BASE_RANGE + level * 10;
            this.rateOfFire = SniperTower.BASE_RATE_OF_FIRE;
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

            this.graphics.beginFill (0xFF3030);
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

                l.alpha -= 0.01;
            }
        }

        private function drawLaser (enemy : Enemy) : Void
        {
            var laser = new Shape ();

            laser.graphics.lineStyle (1, 0xFF3030);
            laser.graphics.moveTo (this.x, this.y);
            laser.graphics.lineTo (enemy.x, enemy.y);

            this.gameStage.addChild (laser);
            this.lasers.push (laser);
        }

}

package td.entity.tower;

import openfl.display.Shape;
import openfl.utils.Timer;
import openfl.events.TimerEvent;

import td.entity.enemy.Enemy;
import td.util.effects.FreezeEffect;

class FreezeTower extends AttackTower
{

        public static inline var BASE_DAMAGE : Float = 10;

        public static inline var BASE_SPEED : Float = 0.5;

        public static inline var BASE_RATE_OF_FIRE : Float = 5000;

        public static inline var BASE_RANGE : Float = 100;

        private var timer : Timer;

        private var splashes : Array<Shape>;

        public function new (level : Int, kills : Int)
        {
            super ();

            this.damage = SplashTower.BASE_DAMAGE + level * 0.2;
            this.speed = SplashTower.BASE_SPEED + level * 0.1;
            this.range = SplashTower.BASE_RANGE + level * 2;
            this.rateOfFire = SplashTower.BASE_RATE_OF_FIRE - level * 5;
            this.kills = kills;
            this.level = level;
            this.splashes = new Array<Shape> ();

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

            this.graphics.beginFill (0x75B6FF);
            this.graphics.drawCircle (0, 0, Tower.RADIUS / 2);
            this.graphics.endFill ();

            super.draw ();
        }

        public function shoot (e : TimerEvent) : Void
        {
            if (!hasEnergy ())
                return;

            var enemies = this.gameStage.getEnemies ();
            var hasAttacked = false;

            for (enemy in enemies)
            {
                var d = sqrDistanceTo (enemy);

                if (d <= this.range * this.range)
                {
                    enemy.addEffect (new FreezeEffect (50, enemy));
                    hasAttacked = true;
                }
            }

            if (hasAttacked)
            {
                drawSplash ();
            }
        }

        override public function update () : Void
        {
            super.update ();

            for (s in splashes)
            {
                if (s.alpha <= 0)
                {
                    this.gameStage.removeChild (s);
                    this.splashes.remove (s);
                }

                s.alpha -= 0.02;
            }
        }

        private function drawSplash () : Void
        {
            var splash = new Shape ();

            splash.graphics.beginFill (0x75B6FF);
            splash.graphics.drawCircle (this.x, this.y, this.range);
            splash.alpha = 0.5;

            this.gameStage.addChild (splash);
            this.splashes.push (splash);
        }

}

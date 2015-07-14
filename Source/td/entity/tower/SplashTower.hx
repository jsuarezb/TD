package td.entity.tower;

import openfl.display.Shape;
import openfl.utils.Timer;
import openfl.events.TimerEvent;

import td.entity.enemy.Enemy;

class SplashTower extends Tower
{

        public static inline var BASE_DAMAGE : Float = 10;

        public static inline var BASE_SPEED : Float = 0.5;

        public static inline var BASE_RATE_OF_FIRE : Float = 2000;

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
        }

        override public function draw () : Void
        {
            super.draw ();

            this.graphics.beginFill (0xFFFFFF);
            this.graphics.drawCircle (0, 0, Tower.WIDTH / 2 - 1);
        }

        public function shoot (e : TimerEvent) : Void
        {
            var enemies = this.gameStage.getEnemies ();
            var hasAttacked = false;

            for (enemy in enemies)
            {
                var d = sqrDistanceTo (enemy);

                if (d <= this.range * this.range)
                {
                    inflictDamage (enemy);
                    hasAttacked = true;
                }
            }

            if (hasAttacked)
            {
                drawSplash ();
            }
        }

        override public function move () : Void
        {
            super.move ();

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

            splash.graphics.beginFill (0xFFFFFF);
            splash.graphics.drawCircle (this.x, this.y, this.range);
            splash.alpha = 0.5;

            this.gameStage.addChild (splash);
            this.splashes.push (splash);
        }

}

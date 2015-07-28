package td.entity.towers;

import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.TimerEvent;

class SplashAttackTower extends AttackTower
{

    private var splashes : Array<Shape>;

    public function new ()
    {
        super ();

        splashes = new Array<Shape> ();
    }

    /**
     * Draw a splash
     */
    private function drawSplash () : Void {}

    override public function shoot (e : TimerEvent) : Void
    {
        if (!hasEnergy ())
            return;

        var enemies = gameStage.getEnemies ();
        var hasAttacked = false;
        for (e in enemies)
        {
            if (inRange (e))
            {
                hasAttacked = true;
                attack (e);
            }
        }

        if (hasAttacked)
            drawSplash ();
    }

    override public function update () : Void
    {
        super.update ();

        for (s in splashes)
        {
            if (s.alpha <= 0)
            {
                gameStage.removeChild (s);
                splashes.remove (s);
            }

            s.alpha -= 0.02;
        }
    }

    override public function inRange (sprite : Sprite) : Bool
    {
        return sqrDistanceTo (sprite) <= range * range;
    }

}

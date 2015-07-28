package td.entity.towers;

import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.TimerEvent;

import td.entity.enemy.Enemy;

enum ShootMode
{
    CLOSE_TOWER;
    FAR_TOWER;
    CLOSE_BASE;
    FAR_BASE;
}

class LaserAttackTower extends AttackTower
{

    private var lasers : Array<Shape>;

    public var shootMode : ShootMode = ShootMode.CLOSE_BASE;

    public function new ()
    {
        super ();

        this.lasers = new Array<Shape> ();
    }

    override public function shoot (e : TimerEvent) : Void
    {
        if (!hasEnergy ())
            return;

        var enemy : Enemy;
        switch (shootMode)
        {
            case CLOSE_TOWER:
                enemy = getEnemyCloserToTower ();

            case FAR_TOWER:
                enemy = getEnemyFurtherFromTower ();

            case CLOSE_BASE:
                enemy = getEnemyCloserToBase ();

            case FAR_BASE:
                enemy = getEnemyFurtherFromBase ();

            default:
                return;
        }

        attack (enemy);
    }

    /**
     * Get the enemy in range, closer to the tower
     * @return  closer enemy
     */
    private function getEnemyCloserToTower () : Enemy
    {
        var target : Enemy = null;
        var enemies = gameStage.getEnemies ();
        var mDist : Float = range * range;

        for (e in enemies)
        {
            var d = sqrDistanceTo (e);
            if (d < mDist)
            {
                mDist = d;
                target = e;
            }
        }

        return target;
    }

    /**
     * Get the enemy in range, further from the tower
     * @return  further enemy
     */
    private function getEnemyFurtherFromTower () : Enemy
    {
        var target : Enemy = null;
        var enemies = gameStage.getEnemies ();
        var minDist : Float = 0;
        var maxDist : Float = this.range * this.range;

        for (e in enemies)
        {
            var d = sqrDistanceTo (e);
            if (inRange (e) && d > minDist)
            {
                minDist = d;
                target = e;
            }
        }

        return target;
    }

    /**
     * Get the enemy in range, closer to the base
     * @return  closer enemy
     */
    private function getEnemyCloserToBase () : Enemy
    {
        var target : Enemy = null;
        var enemies = gameStage.getEnemies ();
        var minDist : Float = Enemy.MAX_DISTANCE_TO_BASE;
        var sqrRange = range * range;

        for (e in enemies)
        {
            var d = sqrDistanceTo (e);
            if (inRange (e) && e.baseDistance < minDist)
            {
                minDist = e.baseDistance;
                target = e;
            }
        }

        return target;
    }

    /**
     * Get the enemy in range, further from the base
     * @return  further enemy
     */
    private function getEnemyFurtherFromBase () : Enemy
    {
        var target : Enemy = null;
        var enemies = gameStage.getEnemies ();
        var minDist : Float = 0;
        var sqrRange = range * range;

        for (e in enemies)
        {
            var d = sqrDistanceTo (e);
            if (inRange (e) && e.baseDistance > minDist)
            {
                minDist = e.baseDistance;
                target = e;
            }
        }

        return target;
    }

    /**
     * Draw a laser from this tower to the enemy
     * @param   enemy   enemy attacked
     */
    private function drawLaser (enemy : Enemy) : Void {}

    override public function update () : Void
    {
        super.update ();

        for (l in lasers)
        {
            if (l.alpha <= 0) {
                gameStage.removeChild (l);
                lasers.remove (l);
            }

            l.alpha -= 0.1;
        }
    }

    override public function inRange (sprite : Sprite) : Bool
    {
        return sqrDistanceTo (sprite) <= range * range;
    }

}

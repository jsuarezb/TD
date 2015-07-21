package td.util.effects;

import td.entity.enemy.*;
import td.util.effects.IEffect;
import td.util.effects.EnemyEffect;

class FreezeEffect extends EnemyEffect
{

    private var enemySpeed : Float;

    public function new (ticks : Int, enemy : Enemy) : Void
    {
        super (EffectType.SPEED, ticks, enemy);
    }

    override public function onStart () : Void
    {
        this.enemySpeed = enemy.speed;
    }

    override public function onEffect () : Void
    {
        enemy.speed = 0;
    }

    override public function onEnd () : Void
    {
        enemy.speed = this.enemySpeed;
    }

}

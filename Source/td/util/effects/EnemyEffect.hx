package td.util.effects;

import td.entity.enemy.Enemy;
import td.util.effects.IEffect;

class EnemyEffect extends Effect
{

    public var enemy (default, null) : Enemy;

    public function new (category : EffectType, ticks : Int, enemy : Enemy)
    {
        super (category, ticks);

        this.enemy = enemy;

        onStart ();
    }

}

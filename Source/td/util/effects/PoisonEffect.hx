package td.util.effects;

import td.entity.enemy.*;
import td.entity.tower.PoisonTower;
import td.util.effects.IEffect;
import td.util.effects.EnemyEffect;

class PoisonEffect extends EnemyEffect
{

    private var tower : PoisonTower;

    private var dps : Float;

    public function new (ticks : Int, enemy : Enemy, dps : Float, tower : PoisonTower) : Void
    {
        super (EffectType.HP, ticks, enemy);

        this.tower = tower;
        this.dps = dps;
    }


    override public function onEffect () : Void
    {
        enemy.takeDamage (tower, dps);
    }

}

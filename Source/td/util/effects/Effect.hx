package td.util.effects;

import td.entity.enemy.Enemy;
import td.util.effects.IEffect;

class Effect implements IEffect
{

    public var category(default, null) : EffectType;

    private var ticks : Int;

    public function new (category : EffectType, ticks : Int)
    {
        this.category = category;
        this.ticks = ticks;
    }


    public function update () : Void
    {
        if (!isDone ())
        {
            onEffect ();
            ticks--;
        }
    }

    public function isDone () : Bool
    {
        return this.ticks == 0;
    }

    public function onStart () : Void { }

    public function onEffect () : Void { }

    public function onEnd () : Void { }

}

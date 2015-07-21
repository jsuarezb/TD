package td.util.effects;

import haxe.ds.EnumValueMap;

import td.util.effects.IEffect;

class EffectsCollection
{

    private var effects : EnumValueMap<EffectType, Array<EnemyEffect>>;

    public function new ()
    {
        this.effects = new EnumValueMap<EffectType, Array<EnemyEffect>> ();
    }

    public function add (effect : EnemyEffect) : Void
    {
        if (!effects.exists (effect.category))
            effects.set (effect.category, new Array<EnemyEffect> ());

        effects.get (effect.category).push (effect);
    }

    public function apply (category : EffectType) : Void
    {
        var effects = this.effects.get (category);

        if (effects == null)
            return;

        for (effect in effects)
        {
            effect.update ();

            if (effect.isDone ())
            {
                effect.onEnd ();
                this.effects.get (effect.category).remove (effect);
            }
        }
    }

}

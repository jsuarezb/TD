package td.util.effects;

enum EffectType
{
    HP;
    SPEED;
    DAMAGE;
}

interface IEffect
{

    public function update () : Void;

    /**
     * Returns true if the effect is gone
     * @return  true if effect is gone, false if not
     */
    public function isDone () : Bool;

    /**
     * Function to be executed when effect starts
     */
    public function onStart () : Void;

    /**
     * Function to be executed while effect's on
     */
    public function onEffect () : Void;

    /**
     * Function to be executed when effect ends
     */
    public function onEnd () : Void;

}

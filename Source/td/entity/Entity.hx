package td.entity;

interface Entity
{

    /**
     * Take damage `d` from entity `e`
     */
    public function takeDamage (e : Attacker, d : Float) : Void;

}

package td.entity.towers;

class SatelliteTower extends Tower
{

    private static inline var NAME : String = "Satellite";

    public static inline var BASE_SPEED : Float = 2;

    public static inline var BASE_RANGE : Float = 150;

    public static inline var RADIUS : Float = 5;

    public function new (level : Int)
    {
        super ();

        this.level = level;
        this.speed = SatelliteTower.BASE_SPEED + this.level * 1 / 20;
        this.range = SatelliteTower.BASE_RANGE + this.level * 5;

        draw ();
    }

    override public function draw () : Void
    {
        this.graphics.beginFill (0xFFFFFF);
        this.graphics.drawCircle (0, 0, SatelliteTower.RADIUS);
        this.graphics.endFill ();

        this.graphics.beginFill (0x333333);
        this.graphics.drawCircle (0, 0, SatelliteTower.RADIUS / 2);
        this.graphics.endFill ();

        super.draw ();
    }

    override public function isSatellite () : Bool
    {
        return true;
    }

    override public function getName () : String
    {
        return NAME;
    }

}

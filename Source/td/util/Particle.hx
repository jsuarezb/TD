package td.util;

class Particle
{

    private static inline var MIN_CHANNEL_VALUE : Int = 0xFF;

    private static inline var MAX_CHANNEL_VALUE : Int = 0x60;

    private static inline var FRICTION : Float = 0.95;

    private static inline var MIN_SPEED : Float = 0.01;

    private static inline var FRAMES_TILL_END : Int = 30;

    public var x : Float;

    public var y : Float;

    public var index : Int;

    public var color : UInt;

    private var xspeed : Float;

    private var yspeed : Float;

    private var framesStopped : Int = 0;

    public function new (x : Float, y : Float, maxSpeed : Float, index : Int) : Void
    {
        var speed = Math.random () * maxSpeed;
        var angle = Math.random () * 2 * Math.PI;

        this.x = x;
        this.y = y;
        this.index = index;

        var r = Std.int (Math.random () * (Particle.MAX_CHANNEL_VALUE - Particle.MIN_CHANNEL_VALUE) + Particle.MIN_CHANNEL_VALUE);
        var g = Std.int (Math.random () * (Particle.MAX_CHANNEL_VALUE - Particle.MIN_CHANNEL_VALUE) + Particle.MIN_CHANNEL_VALUE);
        var b = Std.int (Math.random () * (Particle.MAX_CHANNEL_VALUE - Particle.MIN_CHANNEL_VALUE) + Particle.MIN_CHANNEL_VALUE);
        this.color = 0xFF << 24 | r << 16 | g << 8 | b;

        this.xspeed = speed * Math.cos (angle);
        this.yspeed = speed * Math.sin (angle);
    }

    public function update () : Void
    {
        if (this.xspeed * this.xspeed + this.yspeed * this.yspeed < Particle.MIN_SPEED)
            this.framesStopped++;

        this.xspeed *= Particle.FRICTION;
        this.yspeed *= Particle.FRICTION;

        this.x += this.xspeed;
        this.y += this.yspeed;
    }

    public function isStopped () : Bool
    {
        return this.framesStopped > Particle.FRAMES_TILL_END;
    }

}

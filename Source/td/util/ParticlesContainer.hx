package td.util;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import haxe.ds.IntMap;

class ParticlesContainer extends Sprite
{

    private var _width : Float;

    private var _height : Float;

    private var container : Bitmap;

    private var containerData : BitmapData;

    private var particles : IntMap<Particle>;

    private var counter : Int = 0;

    public function new (width : Float, height : Float) : Void
    {
        super ();

        this._width = width;
        this._height = height;

        containerData = new BitmapData (Std.int (this._width), Std.int (this._height), true, 0x00FFFFFF);
        container = new Bitmap (containerData);
        addChild (container);

        particles = new IntMap<Particle> ();
    }

    public function update () : Void
    {
        containerData.lock ();

        for (p in particles) {
            p.update ();

            if (p.isStopped ())
            {
                particles.remove (p.index);
            }
            else
            {
                eraseParticle (p);
                p.update ();
                drawParticle (p);
            }
        }

        containerData.unlock ();
    }


    public function addParticles (n : Int, x : Float, y : Float, maxSpeed : Float) : Void
    {
        for (i in 0...n)
            addParticle (x, y, maxSpeed);
    }

    private function addParticle (x : Float, y : Float, maxSpeed : Float) : Void
    {
        var particle = new Particle (x, y, maxSpeed, counter++);

        particles.set (particle.index, particle);
    }

    private function drawParticle (p : Particle) : Void
    {
        var x = Std.int (p.x);
        var y = Std.int (p.y);

        containerData
                .setPixel32 (x, y, p.color);

        containerData
                .setPixel32 (x + 1, y, p.color);

        containerData
                .setPixel32 (x, y + 1, p.color);

        containerData
                .setPixel32 (x + 1, y + 1, p.color);
    }

    private function eraseParticle (p : Particle) : Void
    {
        var x = Std.int (p.x);
        var y = Std.int (p.y);

        containerData
                .setPixel32 (x, y, 0);

        containerData
                .setPixel32 (x + 1, y, 0);

        containerData
                .setPixel32 (x, y + 1, 0);

        containerData
                .setPixel32 (x + 1, y + 1, 0);
    }

}

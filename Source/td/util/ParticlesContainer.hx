package td.util;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.ColorTransform;
import haxe.ds.IntMap;

class ParticlesContainer extends Sprite
{

    private var _width : Float;

    private var _height : Float;

    private var container : Bitmap;

    private var containerData : BitmapData;

    private var particles : IntMap<Particle>;

    private var counter : Int = 0;

    private var colorTransform : ColorTransform;

    public function new (width : Float, height : Float) : Void
    {
        super ();

        this._width = width;
        this._height = height;

        this.containerData = new BitmapData (Std.int (this._width), Std.int (this._height), true, 0x00FFFFFF);
        this.container = new Bitmap (containerData);
        addChild (container);

        this.colorTransform = new ColorTransform ();
        this.colorTransform.alphaMultiplier = 0.995;

        this.particles = new IntMap<Particle> ();
    }

    public function update () : Void
    {
        containerData.lock ();

        containerData.colorTransform (containerData.rect, colorTransform);

        for (p in particles) {
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

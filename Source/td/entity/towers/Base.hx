package td.entity.towers;

import openfl.utils.Timer;

import openfl.display.Sprite;
import openfl.display.CapsStyle;
import openfl.display.JointStyle;
import openfl.display.LineScaleMode;
import openfl.display.Shape;

import td.events.TowerEvent;

class Base extends AttackTower
{

    private static inline var NAME : String = "Base";

    private static inline var SIZE : Int = 10;

    private var hp : Float;

    public function new (level : Int, kills : Int)
    {
        super ();

        this.hp = 100;

        this.kills = kills;
        this.level = level;
        this.speed = 0;
        this.range = BasicTower.BASE_RANGE + level * 5;
        this.damage = BasicTower.BASE_DAMAGE + level * 0.2;
        this.rateOfFire = BasicTower.BASE_RATE_OF_FIRE - level * 30;

        this.timer = new Timer (this.rateOfFire);

        draw ();
    }

    override public function draw () : Void
    {
        var size = Base.SIZE;

        this.graphics.lineStyle (3, 0xFFFFFF, 1, true, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER);
        this.graphics.beginFill (0x333333);
        this.graphics.drawRect (-size / 2, -size / 2, size, size);
        this.graphics.endFill ();

        this.rangeIndicator = new Shape ();
        this.rangeIndicator.alpha = 0;
        this.rangeIndicator.graphics.beginFill (0x000000, .25);
        this.rangeIndicator.graphics.drawCircle (0, 0, this.range);
        this.rangeIndicator.graphics.endFill ();

        var hSize = size + 2.5;
        this.highlight = new Shape ();
        this.highlight.alpha = 0;
        this.highlight.graphics.lineStyle (4, 0x3366FF, .75);
        this.highlight.graphics.drawRect (-hSize / 2, -hSize / 2, hSize, hSize);
    }

    override public function takeDamage (e : Entity, d : Float) : Void
    {
        this.hp -= d;

        if (this.hp <= 0) {
            dispatchEvent (new TowerEvent (TowerEvent.BASE_DESTROYED, this));
        }
    }

    // Base will always have energy
    override public function hasEnergy () : Bool
    {
        return true;
    }

    override public function getName () : String
    {
        return NAME;
    }

}

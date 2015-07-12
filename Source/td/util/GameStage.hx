package td.util;

import openfl.display.Sprite;
import openfl.events.Event;

import td.entity.tower.*;
import td.entity.enemy.*;
import td.event.*;

class GameStage extends Sprite
{

    private var towers : Array<Tower>;

    private var enemies : Array<Enemy>;

    private var grid : GameGrid;

    public var _width : Float;

    public var _height : Float;

    private var level:Level;

    private var levelNumber : Int;

    public function new (width : Float, height : Float)
    {
        super ();

        this._width = width;
        this._height = height;

        towers = new Array<Tower> ();
        enemies = new Array<Enemy> ();

        addEventListener (Event.ADDED_TO_STAGE, onAdded);
    }

    public function setLevel (level : Int) : Void
    {
        this.levelNumber = level;
    }

    /**
     * Start to send enemies
     */
    public function startLevel () : Void
    {
        level = new Level (levelNumber, this);
        level.start ();

        level.addEventListener (LevelEvent.END, onLevelEnd);
    }

    public function addEnemy (enemy : Enemy) : Void
    {
        trace ("Adding enemy");
        enemy.setContainer(this);
        enemies.push (enemy);

        addChild (enemy);
    }

    private function onAdded (e:Event) : Void
    {
        removeEventListener (Event.ADDED_TO_STAGE, onAdded);

        trace ("GameStage added");

        addEventListener (Event.ENTER_FRAME, onEnter);
    }

    private function onEnter (e:Event) : Void
    {
        for (e in enemies) {
            e.move ();
        }
    }

    private function onLevelEnd (e:LevelEvent) : Void
    {
        level.removeEventListener(LevelEvent.END, onLevelEnd);

        /* TODO */
    }


}

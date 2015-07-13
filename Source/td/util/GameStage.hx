package td.util;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Point;
import haxe.ds.IntMap;

import td.entity.tower.*;
import td.entity.enemy.*;
import td.entity.PlayerBase;
import td.event.*;

class GameStage extends Sprite
{

    private var towerCounter : Int = 0;

    private var enemyCounter : Int = 0;

    /* TODO implement a hash for towers and enemies */
    private var towers : IntMap<Tower>;

    private var enemies : IntMap<Enemy>;

    private var base : PlayerBase;

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

        this.base = new PlayerBase ();
        this.base.x = this._width / 2;
        this.base.y = this._height / 2;

        this.towers = new IntMap<Tower> ();
        this.enemies = new IntMap<Enemy> ();

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
        this.base.addEventListener (PlayerBaseEvent.BASE_DESTROYED, onBaseDestroyed);

        level = new Level (levelNumber, this);
        level.start ();
    }

    public function addTower (tower : Tower) : Void
    {
        tower.index = towerCounter;
        tower.setGameStage (this);
        towers.set (tower.index, tower);

        addChild (tower);
        towerCounter++;
    }

    public function getEnemies () : IntMap<Enemy>
    {
        return enemies;
    }

    public function addEnemy (enemy : Enemy) : Void
    {
        enemy.index = enemyCounter;
        enemy.setGameStage (this);
        enemies.set (enemy.index, enemy);

        enemy.addEventListener (EnemyEvent.DEAD, removeEnemy);

        addChild (enemy);
        enemyCounter++;
    }

    private function removeEnemy (e : EnemyEvent) : Void
    {
        var enemy = e.enemy;

        enemy.removeEventListener (EnemyEvent.DEAD, removeEnemy);
        enemies.remove (enemy.index);
        removeChild (enemy);
    }

    public function getBase () : PlayerBase
    {
        return this.base;
    }

    private function endLevel (endType : String) : Void
    {
        switch ( endType ) {
            case Level.BASE_DESTROYED:
                trace ("Base destroyed");

            case Level.ENEMIES_DESTROYED:
                trace ("Enemies destroyed");

            default:
                throw "Non existent level end";
        }

    }

    private function onAdded (e : Event) : Void
    {
        removeEventListener (Event.ADDED_TO_STAGE, onAdded);

        addEventListener (Event.ENTER_FRAME, onEnter);
    }

    private function onEnter (e : Event) : Void
    {
        /* REVIEW iterator() returns a new Iterator instance or a copy */
        if (level.enemiesRemaining() == 0 && !enemies.iterator().hasNext()) {
            endLevel (Level.ENEMIES_DESTROYED);
        }

        for (t in towers)
        {
            t.move ();
        }

        for (e in enemies)
        {
            e.move ();
        }
    }

    private function onBaseDestroyed (e : PlayerBaseEvent) : Void
    {
        endLevel (Level.BASE_DESTROYED);
    }

}

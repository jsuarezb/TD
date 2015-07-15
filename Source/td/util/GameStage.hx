package td.util;

import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.display.GradientType;
import openfl.geom.Matrix;
import haxe.ds.IntMap;

import td.entity.tower.*;
import td.entity.enemy.*;
import td.entity.PlayerBase;
import td.event.*;
import td.util.ParticlesContainer;

class GameStage extends Sprite
{

    private static inline var MIN_SELECT_RANGE : Float = 20;

    private var towerCounter : Int = 0;

    private var enemyCounter : Int = 0;

    /* TODO implement a hash for towers and enemies */
    private var towers : IntMap<Tower>;

    private var enemies : IntMap<Enemy>;

    private var towerSelected : Tower = null;

    private var base : PlayerBase;

    private var grid : GameGrid;

    public var _width : Float;

    public var _height : Float;

    private var level:Level;

    private var levelNumber : Int;

    private var particles : ParticlesContainer;

    private var towersEffects : Sprite;

    public function new (width : Float, height : Float)
    {
        super ();

        this._width = width;
        this._height = height;

        drawBackground ();
        drawParticlesContainer ();
        drawTowersEffects ();

        this.base = new PlayerBase ();
        this.base.x = this._width / 2;
        this.base.y = this._height / 2;

        this.towers = new IntMap<Tower> ();
        this.enemies = new IntMap<Enemy> ();

        addEventListener (Event.ADDED_TO_STAGE, onAdded);
    }

    private function onAdded (e : Event) : Void
    {
        removeEventListener (Event.ADDED_TO_STAGE, onAdded);

        addEventListener (Event.ENTER_FRAME, onEnter);
        addEventListener (MouseEvent.CLICK, onClick);
    }

    private function drawBackground () : Void
    {
        var bg : Shape = new Shape ();
        var mtx : Matrix = new Matrix ();
        mtx.createGradientBox (this._width, this._height, Math.PI * 45 / 180, 0, 0);

        bg.graphics.beginGradientFill (
            GradientType.LINEAR,
            [0xF24A87, 0xF8A248],
            [1, 1],
            [0, 255],
            mtx
        );
        bg.graphics.drawRect (0, 0, this._width, this._height);
        bg.graphics.endFill ();
        addChild (bg);
    }

    private function drawParticlesContainer() : Void
    {
        this.particles = new ParticlesContainer (this._width, this._height);

        addChild (this.particles);
    }

    private function drawTowersEffects () : Void
    {
        this.towersEffects = new Sprite ();

        addChild (this.towersEffects);
    }

    public function addTowerEffect (d : DisplayObject) : Void
    {
        this.towersEffects.addChild (d);
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

    private function highlightTower () : Void
    {
        var xdif, ydif, tDist, tower = null;
        var minDist = GameStage.MIN_SELECT_RANGE * GameStage.MIN_SELECT_RANGE;

        for (t in towers)
        {
            if (!t.isSelected)
                t.isHighlighted = false;

            xdif = t.x - stage.mouseX;
            ydif = t.y - stage.mouseY;

            tDist = xdif * xdif + ydif * ydif;
            if (tDist <= minDist)
            {
                minDist = tDist;
                tower = t;
            }
        }

        if (tower != null)
            tower.isHighlighted = true;
    }

    private function selectTower (t : Tower) : Void
    {
        if (this.towerSelected != null)
            deselectTower ();

        t.isSelected = true;
        this.towerSelected = t;
    }

    private function deselectTower () : Void
    {
        towerSelected.isHighlighted = false;
        towerSelected.isSelected = false;
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

        enemy.addEventListener (EnemyEvent.DEAD, onEnemyDead);

        addChild (enemy);
        enemyCounter++;
    }

    private function removeEnemy (enemy : Enemy) : Void
    {
        enemy.removeEventListener (EnemyEvent.DEAD, removeEnemy);
        enemies.remove (enemy.index);
        removeChild (enemy);
    }

    private function onEnemyDead (e : EnemyEvent) : Void
    {
        var enemy = e.enemy;

        particles.addParticles (25, enemy.x, enemy.y, 5);

        removeEnemy (enemy);
    }

    public function getBase () : PlayerBase
    {
        return this.base;
    }

    public function getParticles () : ParticlesContainer
    {
        return this.particles;
    }

    private function endLevel (endType : String) : Void
    {
        switch ( endType ) {
            case Level.BASE_DESTROYED:


            case Level.ENEMIES_DESTROYED:


            default:
                throw "Non existent level end";
        }

    }

    private function onEnter (e : Event) : Void
    {
        /* REVIEW iterator() returns a new Iterator instance or a copy */
        if (level.enemiesRemaining() == 0 && !enemies.iterator().hasNext()) {
            endLevel (Level.ENEMIES_DESTROYED);
        }

        for (t in towers)
        {
            t.update ();
        }
        highlightTower ();

        for (e in enemies)
        {
            e.move ();
        }

        particles.update ();
    }

    private function onBaseDestroyed (e : PlayerBaseEvent) : Void
    {
        endLevel (Level.BASE_DESTROYED);
    }

    private function onClick (e : MouseEvent) : Void
    {
        var xdif, ydif, currDist;
        var dist = GameStage.MIN_SELECT_RANGE * GameStage.MIN_SELECT_RANGE;
        var tSelected : Tower = null;

        for (t in towers)
        {
            xdif = stage.mouseX - this.x - t.x;
            ydif = stage.mouseY - this.y - t.y;
            currDist = xdif * xdif + ydif * ydif;

            if (currDist < dist)
            {
                tSelected = t;
                dist = currDist;
            }
        }

        if (tSelected != null && tSelected != this.towerSelected) selectTower (tSelected);
        else this.towerSelected.moveTo (stage.mouseX - this.x, stage.mouseY - this.y);
    }

}

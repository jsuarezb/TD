package td.view.components;

import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.KeyboardEvent;
import openfl.geom.Point;
import openfl.display.GradientType;
import openfl.geom.Matrix;
import haxe.ds.IntMap;

import td.entity.tower.*;
import td.entity.enemy.*;
import td.event.*;
import td.util.*;

class GameStage extends Sprite
{

    private static inline var MIN_SELECT_RANGE : Float = 20;

    private var towerCounter : Int = 0;

    private var enemyCounter : Int = 0;

    /* TODO implement a hash for towers and enemies */
    private var towers : IntMap<Tower>;

    private var enemies : IntMap<Enemy>;

    private var satellitesRange : TowersRange;

    private var satellites : Array<Tower>;

    private var towerSelected : Tower = null;

    private var base : PlayerBase;

    public var _width : Float;

    public var _height : Float;

    private var level:Level;

    private var levelNumber : Int;

    private var particles : ParticlesContainer;

    private var towersEffects : Sprite;

    private var keyboard : Keyboard;

    public function new (width : Float, height : Float)
    {
        super ();

        this._width = width;
        this._height = height;

        this.towers = new IntMap<Tower> ();
        this.enemies = new IntMap<Enemy> ();
        this.satellites = new Array<Tower> ();

        drawBackground ();
        drawParticlesContainer ();
        drawTowersEffects ();

        this.base = new PlayerBase (1, 0);
        addTower (this.base);
        this.base.x = this._width / 2;
        this.base.y = this._height / 2;

        drawTowers ();

        addEventListener (Event.ADDED_TO_STAGE, onAdded);
    }

    private function onAdded (e : Event) : Void
    {
        removeEventListener (Event.ADDED_TO_STAGE, onAdded);

        setKeyboard ();

        addEventListener (Event.ENTER_FRAME, onEnter);
        addEventListener (MouseEvent.CLICK, onClick);
    }

    public function getBase () : PlayerBase
    {
        return base;
    }

    public function getParticles () : ParticlesContainer
    {
        return particles;
    }

    public function setKeyboard () : Void
    {
        keyboard = new Keyboard (stage);
        keyboard.onKeyPressed (Keyboard.ESC_KEY, deselectTower);
    }

    public function setLevel (level : Int) : Void
    {
        levelNumber = level;
    }

    private function drawBackground () : Void
    {
        var bg : Shape = new Shape ();
        var mtx : Matrix = new Matrix ();
        mtx.createGradientBox (_width, _height, Math.PI / 4, 0, 0);

        bg.graphics.beginGradientFill (
            GradientType.LINEAR,
            [0xF24A87, 0xF8A248],
            [1, 1],
            [0, 255],
            mtx
        );
        bg.graphics.drawRect (0, 0, _width, _height);
        bg.graphics.endFill ();
        addChild (bg);
    }

    private function drawParticlesContainer() : Void
    {
        particles = new ParticlesContainer (_width, _height);

        addChild (particles);
    }

    private function drawTowersEffects () : Void
    {
        towersEffects = new Sprite ();

        addChild (towersEffects);
    }

    private function drawTowers () : Void
    {
        var t = Tower.create (Tower.SPLASH_TOWER, 1);
		t.x = 300;
		t.y = 200;
		addTower (t);

        var t = Tower.create (Tower.BASIC_TOWER, 1);
		t.x = 300;
		t.y = 400;
		addTower (t);

        var t = Tower.create (Tower.PLUS_TOWER, 1);
		t.x = 200;
		t.y = 400;
		addTower (t);

        var t = Tower.create (Tower.SNIPER_TOWER, 1);
		t.x = 200;
		t.y = 200;
		addTower (t);

        var t = Tower.create (Tower.FREEZE_TOWER, 1);
		t.x = 400;
		t.y = 200;
		addTower (t);

        var t = Tower.create (Tower.POISON_TOWER, 1);
		t.x = 400;
		t.y = 400;
		addTower (t);

        var t = Tower.create (Tower.SATELLITE_TOWER, 1);
        t.x = 400;
        t.y = 300;
        addTower (t);

        var t = Tower.create (Tower.SATELLITE_TOWER, 1);
        t.x = 200;
        t.y = 300;
        addTower (t);
    }

    public function addTowerEffect (d : DisplayObject) : Void
    {
        towersEffects.addChild (d);
    }

    /**
     * Start to send enemies
     */
    public function startLevel () : Void
    {
        base.addEventListener (PlayerBaseEvent.BASE_DESTROYED, onBaseDestroyed);

        level = new Level (levelNumber, this);
        level.start ();
    }

    public function addTower (tower : Tower) : Void
    {
        tower.index = towerCounter;
        tower.setGameStage (this);
        towers.set (tower.index, tower);

        if (tower.isSatellite ())
            satellites.push (tower);

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
            if (tDist <= minDist && t.hasEnergy ())
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
        if (towerSelected != null)
            deselectTower ();

        t.isSelected = true;
        towerSelected = t;
    }

    private function deselectTower () : Void
    {
        if (towerSelected == null)
            return;

        towerSelected.isHighlighted = false;
        towerSelected.isSelected = false;
        towerSelected = null;
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

    private function endLevel (endType : String) : Void
    {
        switch ( endType ) {
            case Level.BASE_DESTROYED:


            case Level.ENEMIES_DESTROYED:


            default:
                throw "Non existent level end";
        }

    }

    private function generateSatellitesRange () : Void
    {
        satellitesRange = new TowersRange (base);
        satellitesRange.addSatellites (satellites);
    }

    public function getSatellitesRange () : TowersRange
    {
        return satellitesRange;
    }

    public function showSatelliteRanges () : Void
    {
        base.showRange ();
        for (s in satellites)
            s.showRange ();
    }

    private function onEnter (e : Event) : Void
    {
        /* REVIEW iterator() returns a new Iterator instance or a copy */
        if (level.enemiesRemaining () == 0 && !enemies.iterator ().hasNext ())
            endLevel (Level.ENEMIES_DESTROYED);

        generateSatellitesRange ();

        for (t in towers)
            t.update ();

        highlightTower ();
        if (keyboard.isPressed (Keyboard.X_KEY)) showSatelliteRanges ();

        for (e in enemies)
            e.update ();

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

            if (currDist < dist && t.hasEnergy ())
            {
                tSelected = t;
                dist = currDist;
            }
        }

        if (tSelected != null && tSelected != this.towerSelected) selectTower (tSelected);
        else this.towerSelected.moveTo (stage.mouseX - this.x, stage.mouseY - this.y);
    }

}

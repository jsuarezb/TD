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

    private var energyRange : EnergyRange;

    private var towerSelected : Tower = null;

    private var base : PlayerBase;

    public var _width : Float;

    public var _height : Float;

    private var level:Level;

    private var levelNumber : Int;

    private var particles : ParticlesContainer;

    private var towersEffects : Sprite;

    private var keyboard : Keyboard;

    public var isPaused : Bool = false;

    public function new (width : Float, height : Float)
    {
        super ();

        this._width = width;
        this._height = height;

        this.towers = new IntMap<Tower> ();
        this.enemies = new IntMap<Enemy> ();

        drawBackground ();
        drawParticlesContainer ();
        drawTowersEffects ();

        this.base = new PlayerBase (1, 0);
        this.base.x = this._width / 2;
        this.base.y = this._height / 2;
        this.energyRange = new EnergyRange (this.base);
        addTower (this.base);

        drawTowers ();

        addEventListener (Event.ADDED_TO_STAGE, onAdded);
    }

    private function onAdded (e : Event) : Void
    {
        removeEventListener (Event.ADDED_TO_STAGE, onAdded);

        setKeyboard ();

        addEventListener (Event.ENTER_FRAME, onEnter);
        addEventListener (MouseEvent.CLICK, onClick);

        dispatchEvent (new GameEvent (GameEvent.RESUME));
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
        keyboard = Keyboard.getInstance (stage);
        keyboard.onKeyPressed (Keyboard.ESC_KEY, deselectTower);
        keyboard.onKeyPressed (Keyboard.P_KEY, togglePause);
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
        var t = Tower.create (Tower.SPLASH_TOWER, 20);
		t.x = 300;
		t.y = 200;
		addTower (t);

        var t = Tower.create (Tower.BASIC_TOWER, 20);
		t.x = 300;
		t.y = 400;
		addTower (t);

        var t = Tower.create (Tower.PLUS_TOWER, 20);
		t.x = 200;
		t.y = 400;
		addTower (t);

        var t = Tower.create (Tower.SNIPER_TOWER, 20);
		t.x = 200;
		t.y = 200;
		addTower (t);

        var t = Tower.create (Tower.FREEZE_TOWER, 20);
		t.x = 400;
		t.y = 200;
		addTower (t);

        var t = Tower.create (Tower.POISON_TOWER, 20);
		t.x = 400;
		t.y = 400;
		addTower (t);

        var t = Tower.create (Tower.SATELLITE_TOWER, 20);
        t.x = 400;
        t.y = 300;
        addTower (t);

        var t = Tower.create (Tower.SATELLITE_TOWER, 20);
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

    /**
     * Add a new tower to the game stage
     * @param   tower   tower to be added
     */
    public function addTower (tower : Tower) : Void
    {
        tower.index = towerCounter;
        tower.setGameStage (this);
        towers.set (tower.index, tower);

        if (tower.isSatellite ())
            energyRange.push (tower);

        addChild (tower);
        towerCounter++;
    }

    /**
     * Highlight a tower if near cursor
     */
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

    /**
     * Select a tower
     * @param   t   tower to be selected
     */
    private function selectTower (t : Tower) : Void
    {
        if (towerSelected != null)
            deselectTower ();

        t.isSelected = true;
        towerSelected = t;
    }

    /**
     * Deselect the tower selected
     */
    private function deselectTower () : Void
    {
        if (towerSelected == null)
            return;

        towerSelected.isHighlighted = false;
        towerSelected.isSelected = false;
        towerSelected = null;
    }

    public function getEnergyRange () : EnergyRange
    {
        return energyRange;
    }

    /**
     * Get the enemies on stage
     * @return  map of enemies with enemy index as key and enemy as value
     */
    public function getEnemies () : IntMap<Enemy>
    {
        return enemies;
    }

    /**
     * Add a new enemy to the game stage
     * @param   enemy   enemy to be added
     */
    public function addEnemy (enemy : Enemy) : Void
    {
        enemy.index = enemyCounter;
        enemy.setGameStage (this);
        enemies.set (enemy.index, enemy);

        enemy.addEventListener (EnemyEvent.DEAD, onEnemyDead);

        addChild (enemy);
        enemyCounter++;
    }

    /**
     * Remove an enemy from the game stage
     * @param   enemy   enemy to be removed
     */
    private function removeEnemy (enemy : Enemy) : Void
    {
        enemy.removeEventListener (EnemyEvent.DEAD, onEnemyDead);
        enemies.remove (enemy.index);
        removeChild (enemy);
    }

    /**
     * Callback to be executed when an enemy dies
     * @param   e   enemy event
     */
    private function onEnemyDead (e : EnemyEvent) : Void
    {
        var enemy = e.enemy;

        particles.addParticles (enemy.getParticles (), enemy.x, enemy.y, 5);
        removeEnemy (enemy);
    }

    /**
     * Decide what how to end the level, based on endType
     * @param   endType type of end of level. The values are:
     *                  Level.BASE_DESTROYED when the base has been destroyed.
     *                  Level.ENEMIES_DESTROYED when every enemy of the level
     *                  has been killed.
     */
    private function endLevel (endType : String) : Void
    {
        switch ( endType ) {
            case Level.BASE_DESTROYED:
                destroy ();

            case Level.ENEMIES_DESTROYED:
                destroy ();

            default:
                throw "Non existent level end";
        }

    }

    /**
     * Pause every object on stage
     */
    public function pause () : Void
    {
        isPaused = true;
        for (t in towers)
            t.pause ();

        level.pause ();
        dispatchEvent (new GameEvent (GameEvent.PAUSE));
    }

    /**
     * Unpause every object on stage
     */
    public function resume () : Void
    {
        isPaused = false;
        for (t in towers)
            t.resume ();

        level.resume ();
        dispatchEvent (new GameEvent (GameEvent.RESUME));
    }

    /**
     * Pause or unpause every object on stage, depending on current state
     */
    public function togglePause () : Void
    {
        if (isPaused) resume ();
        else pause ();
    }

    /**
     * Callback of Event.ENTER_FRAME event, to be executed every frame
     * @param   e   Event
     */
    private function onEnter (e : Event) : Void
    {
        /* TODO pause and resumed gameplay */
        if (isPaused)
            return;

        /* REVIEW iterator() returns a new Iterator instance or a copy */
        if (level.enemiesRemaining () == 0 && !enemies.iterator ().hasNext ())
            endLevel (Level.ENEMIES_DESTROYED);

        energyRange.generate ();

        for (t in towers)
            t.update ();

        highlightTower ();
        if (keyboard.isPressed (Keyboard.X_KEY)) energyRange.showRange ();

        for (e in enemies)
            e.update ();

        particles.update ();
    }

    private function onBaseDestroyed (e : PlayerBaseEvent) : Void
    {
        endLevel (Level.BASE_DESTROYED);
    }

    /**
     * Callback of MouseEvent.CLICK event
     * @param   e   MouseEvent
     */
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

    /**
     * Destroys all the listeners
     */
    public function destroy () : Void
    {
        removeEventListener (Event.ENTER_FRAME, onEnter);
        removeEventListener (MouseEvent.CLICK, onClick);

        level.destroy ();
        base.removeEventListener (PlayerBaseEvent.BASE_DESTROYED, onBaseDestroyed);
        for (t in towers)
            t.destroy ();

        for (e in enemies)
        {
            e.removeEventListener (EnemyEvent.DEAD, onEnemyDead);
            e.destroy ();
        }
    }

}

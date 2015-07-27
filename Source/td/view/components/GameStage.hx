package td.view.components;

import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.KeyboardEvent;
import openfl.geom.Point;
import haxe.ds.IntMap;

import td.entity.tower.*;
import td.entity.enemy.*;
import td.events.*;
import td.util.*;

class GameStage extends Sprite
{

    private static inline var MIN_SELECT_RANGE : Float = 20;

    private var towerCounter : Int = 0;

    private var enemyCounter : Int = 0;

    private var towers : IntMap<Tower>;

    private var enemies : IntMap<Enemy>;

    private var towerSelected : Tower = null;

    private var energyRange : EnergyRange;

    private var base : Base;

    public var isPaused : Bool = false;

    public var _width : Float;

    public var _height : Float;

    private var level:Level;

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

        drawParticlesContainer ();
        drawTowersEffects ();

        this.base = new Base (1, 0);
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

    public function getBase () : Base
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
        for (i in 0...360)
        {
            if (i % 20 == 0)
            {
                var t = Tower.create (Tower.BASIC_TOWER, 20);
                t.x = 300 + 70 * Math.cos (i * Math.PI / 180);
                t.y = 300 + 70 * Math.sin (i * Math.PI / 180);
                addTower (t);
            }
        }

    }

    public function addTowerEffect (d : DisplayObject) : Void
    {
        towersEffects.addChild (d);
    }

    /**
     * Start to send enemies
     */
    public function startLevel (level : Int) : Void
    {
        base.addEventListener (TowerEvent.BASE_DESTROYED, onBaseDestroyed);

        this.level = new Level (level, this);
        this.level.start ();
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
        if (towerSelected != null)
            return;

        dispatchEvent (new TowerEvent (TowerEvent.UNHIGHLIGHT, null));

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
        {
            tower.isHighlighted = true;
            dispatchEvent (new TowerEvent (TowerEvent.HIGHLIGHT, tower));
        }
    }

    /**
     * Select a tower
     * @param   t   tower to be selected
     */
    private function selectTower (t : Tower) : Void
    {
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
        if (isPaused)
            return;

        /* TODO
        if (level.enemiesRemaining () == 0 && !enemies.iterator ().hasNext ())
            endLevel (Level.ENEMIES_DESTROYED);
        */
        if (keyboard.isPressed (Keyboard.X_KEY)) energyRange.showRange ();

        for (e in enemies)
            e.update ();

        energyRange.generate ();

        for (t in towers)
            t.update ();

        highlightTower ();

        particles.update ();
    }

    private function onBaseDestroyed (e : TowerEvent) : Void
    {
        /* TODO */
    }

    /**
     * Callback of MouseEvent.CLICK event
     * @param   e   MouseEvent
     */
    private function onClick (e : MouseEvent) : Void
    {
        if (isPaused) return;

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

        if (tSelected != null && towerSelected == null) selectTower (tSelected);
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
        base.removeEventListener (TowerEvent.BASE_DESTROYED, onBaseDestroyed);
        for (t in towers)
            t.destroy ();

        for (e in enemies)
        {
            e.removeEventListener (EnemyEvent.DEAD, onEnemyDead);
            e.destroy ();
        }
    }

}

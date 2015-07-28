package td.events;

import openfl.events.Event;

import td.entity.towers.Tower;

class TowerEvent extends Event
{

    public static inline var BASE_DESTROYED : String = "base_destroyed";

    public static inline var HIGHLIGHT : String = "tower_highlight";

    public static inline var UNHIGHLIGHT : String = "tower_unhighlight";

    public var tower : Tower;

    public function new (label : String, tower : Tower, bubbles : Bool = false, cancelable : Bool = false)
    {
        super (label, bubbles, cancelable);

        this.tower = tower;
    }

}

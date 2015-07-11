package;

import openfl.display.Sprite;
import openfl.events.Event;

import td.entity.*;

class Main extends Sprite
{

	var towers:Array<Tower>;

	public function new ()
	{
		super();

		this.towers = new Array<Tower> ();

		var tower = new Tower (10, 1, 10, 10, 10);
		this.towers.push (tower);
		this.stage.addChild (tower);

		tower.isSelected = true;
		tower.moveTo (70, 250);

		this.stage.addEventListener (Event.ENTER_FRAME, onEnter);
	}

	private function onEnter (e : Event) : Void
	{
		for (t in towers) {
			t.move ();
		}
	}


}

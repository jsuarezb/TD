package;

import openfl.display.Sprite;
import openfl.events.Event;

import td.util.*;
import td.entity.tower.Tower;

class Main extends Sprite
{

	public function new ()
	{
		super ();

		var gStage = new GameStage (600, 600);
		this.stage.addChild (gStage);

		var t = Tower.create (Tower.SIMPLE_TOWER, 1, 0);
		gStage.addTower (t);
		t.isSelected = true;
		t.moveTo (200, 200);

		var t = Tower.create (Tower.SIMPLE_TOWER, 1, 0);
		gStage.addTower (t);
		t.isSelected = true;
		t.moveTo (200, 300);

		gStage.setLevel (0);
		gStage.startLevel ();
	}

}

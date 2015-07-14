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

		var t = Tower.create (Tower.SNIPER_TOWER, 20, 0);
		gStage.addTower (t);
		t.isSelected = true;
		t.moveTo (200, 200);

		var t = Tower.create (Tower.SPLASH_TOWER, 20, 0);
		gStage.addTower (t);
		t.x = 500;
		t.y = 200;
		t.isSelected = true;
		t.moveTo (400, 300);

		var t = Tower.create (Tower.BASIC_TOWER, 20, 0);
		gStage.addTower (t);
		t.x = 200;
		t.y = 300;

		gStage.setLevel (0);
		gStage.startLevel ();
	}

}

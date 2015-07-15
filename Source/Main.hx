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

		var t = Tower.create (Tower.BASIC_TOWER, 20, 0);
		t.x = 400;
		t.y = 300;
		gStage.addTower (t);

		var t = Tower.create (Tower.BASIC_TOWER, 20, 0);
		t.y = 300;
		t.x = 200;
		gStage.addTower (t);

		var t = Tower.create (Tower.SNIPER_TOWER, 20, 0);
		t.x = 300;
		t.y = 300;
		gStage.addTower (t);

		var t = Tower.create (Tower.SPLASH_TOWER, 20, 0);
		t.x = 300;
		t.y = 200;
		gStage.addTower (t);

		var t = Tower.create (Tower.SPLASH_TOWER, 20, 0);
		t.x = 300;
		t.y = 400;
		gStage.addTower (t);

		gStage.setLevel (0);
		gStage.startLevel ();
	}

}

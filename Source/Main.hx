package;

import openfl.display.Sprite;
import openfl.events.Event;

import td.view.screens.*;

class Main extends Sprite
{

	public function new ()
	{
		super ();

		var gScreen = new GameScreen ();
		this.stage.addChild (gScreen);
	}

}

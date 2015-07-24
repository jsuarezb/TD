package;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.FPS;

import td.view.screens.*;

class Main extends Sprite
{

	public function new ()
	{
		super ();

		var gScreen = new GameScreen ();
		this.stage.addChild (gScreen);

		var fps:FPS = new FPS(10, 560, 0xFFFFFF);
		this.stage.addChild(fps);
	}

}

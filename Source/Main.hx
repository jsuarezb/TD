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

		var screens = new ScreenContainer (new MainMenuScreen ());
		stage.addChild (screens);

		var fps:FPS = new FPS(10, 560, 0xFFFFFF);
		stage.addChild(fps);
	}

}

package;

import openfl.display.Sprite;
import openfl.events.Event;

import td.util.*;
import td.entity.*;

class Main extends Sprite
{

	public function new ()
	{
		super ();

		var gStage = new GameStage (this.stage.stageWidth, this.stage.stageHeight);
		this.stage.addChild (gStage);

		gStage.setLevel (0);
		gStage.startLevel ();
	}


}

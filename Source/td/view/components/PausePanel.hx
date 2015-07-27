package td.view.components;

import openfl.display.Sprite;
import openfl.events.Event;

import td.view.components.GameTextField;

class PausePanel extends Sprite
{

    public function new ()
    {
        super ();

        addEventListener (Event.ADDED_TO_STAGE, onAdded);
    }

    private function onAdded (e : Event) : Void
    {
        removeEventListener (Event.ADDED_TO_STAGE, onAdded);

        this.graphics.beginFill (0xDCB099, 0.4);
        this.graphics.drawRect (0, 0, stage.stageWidth, stage.stageHeight);
        this.graphics.endFill ();

        var pauseTxt = new GameTextField ();
        pauseTxt.setFontSize (24);
        pauseTxt.text = "Pause";
        pauseTxt.textColor = 0xFFC89A;
        pauseTxt.x = (stage.stageWidth - pauseTxt.textWidth) / 2;
        pauseTxt.y = 200;
        addChild (pauseTxt);
    }

}

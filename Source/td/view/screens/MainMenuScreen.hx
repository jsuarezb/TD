package td.view.screens;

import openfl.display.Sprite;
import openfl.display.SimpleButton;
import openfl.events.MouseEvent;

import td.view.components.GameTextField;
import td.events.ScreenEvent;

class MainMenuScreen extends Screen
{

    private var button : SimpleButton;

    public function new ()
    {
        super ();

        var buttonGraphics = new Sprite ();
        var txt = new GameTextField ();
        txt.setFontSize (20);
        buttonGraphics.graphics.lineStyle (2, 0x000000);
        buttonGraphics.graphics.drawRect (0, 0, 50, 20);
        buttonGraphics.addChild (txt);

        button = new SimpleButton (buttonGraphics, buttonGraphics, buttonGraphics, buttonGraphics);
        button.x = 300;
        button.y = 300;
        addChild (button);

        button.addEventListener (MouseEvent.CLICK, onButtonClick);
    }

    private function onButtonClick (e : MouseEvent) : Void
    {
        transitionTo (new GameScreen ());
    }

    override public function destroy () : Void
    {
        button.removeEventListener (MouseEvent.CLICK, onButtonClick);
    }

}

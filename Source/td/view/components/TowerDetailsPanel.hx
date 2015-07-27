package td.view.components;

import openfl.display.Sprite;

import td.entity.tower.Tower;

class TowerDetailsPanel extends Sprite
{

    private var towerName : GameTextField;

    public function new ()
    {
        super ();

        towerName = new GameTextField ();
        towerName.textColor = 0xFFFFFF;
        towerName.x = towerName.y = 5;
        towerName.setFontSize (20);
        addChild (towerName);
    }

    public function show (t : Tower) : Void
    {
        towerName.text = t.getName () + " " + t.level;
        alpha = 1;
    }

    public function hide () : Void
    {
        alpha = 0;
    }

}

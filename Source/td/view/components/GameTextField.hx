package td.view.components;

import openfl.Assets;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.text.AntiAliasType;
import openfl.filters.BitmapFilter;
import openfl.filters.GlowFilter;
import openfl.filters.BitmapFilterQuality;

class GameTextField extends TextField
{

    public static var kontrapunktBobLight : Font =
            Assets.getFont ("assets/MAXWELL REGULAR.ttf");

    public var format : TextFormat;

    public function new ()
    {
        super ();

        format = new TextFormat (GameTextField.kontrapunktBobLight.fontName);
        format.bold = true;
        this.defaultTextFormat = format;

        var outline = new GlowFilter ();
        outline.blurX = outline.blurY = 1.5;
        outline.color = 0x666666;
        outline.quality = BitmapFilterQuality.HIGH;
        outline.strength = 100;

        var filters = new Array<BitmapFilter> ();
        filters.push (outline);

        this.embedFonts = true;
        this.selectable = false;
        this.filters = filters;
        /*this.antiAliasType = AntiAliasType.ADVANCED;*/
    }

    public function setFontSize (size : Null<Float>) : Void
    {
        format.size = size;

        // Here assignation is needed because it does not references format
        // pointer; an update on format does not reflects on defaultTextFormat
        this.defaultTextFormat = format;
    }

    public function setAlignment (alignment : TextFormatAlign) : Void
    {
        format.align = alignment;
    }

}

package td.util;

import haxe.ds.IntMap;
import openfl.Vector;
import openfl.display.Stage;
import openfl.events.KeyboardEvent;

class Keyboard
{

    public static inline var ESC_KEY : Int = 27;

    public static inline var X_KEY : Int = 88;

    private static inline var BUFFER_SIZE : Int = 255;

    private var stage : Stage;

    private var keys : Vector<Bool>;

    private var callbacks : IntMap<Void -> Void>;

    /**
     * Keyboard instance constructor
     * @param   stage   stage to add keyboard event listeners
     */
    public function new (stage : Stage)
    {
        this.stage = stage;
        this.callbacks = new IntMap<Void -> Void> ();
        this.keys = new Vector<Bool>(Keyboard.BUFFER_SIZE, true);
        for (i in 0...Keyboard.BUFFER_SIZE)
            this.keys[i] = false;

        this.stage.addEventListener (KeyboardEvent.KEY_DOWN, onKeyDown);
        this.stage.addEventListener (KeyboardEvent.KEY_UP, onKeyUp);
    }

    /**
     * Destroy the listeners and allows gc to remove the object from memory
     */
    public function destroy () : Void
    {
        stage.removeEventListener (KeyboardEvent.KEY_DOWN, onKeyDown);
        stage.removeEventListener (KeyboardEvent.KEY_UP, onKeyUp);
    }

    /**
     * Check if the key is pressed
     * @param   keyCode code of the key
     * @return  true if the key is pressed, false if not
     */
    public function isPressed (keyCode : Int) : Bool
    {
        return keys[keyCode];
    }

    /**
     * Set a callback function to be executed on the specified key press
     * @param   keyCode code of the key
     * @param   callback    callback function
     */
    public function onKeyPressed (keyCode : Int, callback : Void -> Void) : Void
    {
        if (!isKeySupported (keyCode))
            return;

        callbacks.set (keyCode, callback);
    }

    /**
     * Check if the key is supported
     * @param   keyCode code of the key
     * @return  true if keyCode is supported, false if not
     */
    private inline function isKeySupported (keyCode : Int) : Bool
    {
        return keyCode < BUFFER_SIZE;
    }

    private function onKeyDown (e : KeyboardEvent) : Void
    {
        if (!isKeySupported (e.keyCode))
            return;

        if (callbacks.exists (e.keyCode) && callbacks.get (e.keyCode) != null)
            (callbacks.get (e.keyCode)) ();

        keys[e.keyCode] = true;
    }

    private function onKeyUp (e : KeyboardEvent) : Void
    {
        if (!isKeySupported (e.keyCode))
            return;

        keys[e.keyCode] = false;
    }

}

package td.util;

import openfl.net.SharedObject;

class GameSave
{

    private static inline var SAVE_NAME : String = "aaaagria";

    private static inline var instance : GameSave;

    public static function getInstance () : GameSave
    {
        if (instance == null)
            instance = new GameSave ();

        return instance;
    }

    public var so : SharedObject;

    public function new ()
    {
        this.so = SharedObject.getLocal (GameSave.SAVE_NAME);
    }

}

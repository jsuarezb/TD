package td.util;

import haxe.ds.ObjectMap;

import td.entity.tower.*;

class TowersRange
{

    private var satellites : Array<Tower>;

    public function new (base : PlayerBase)
    {
        satellites = new Array<Tower> ();
        satellites.push (base);
    }

    /**
     * Return if specified point is inside the range of at least one satellite
     *
     * @param   x   x coordinate
     * @param   y   y coordinate
     * @param   [tower] specify satellite
     * @param   isSatellite if tower is satellite
     */
    public function isPointInside (x : Float, y : Float, ?tower : Tower) : Bool
    {
        var range, xdif, ydif, dist;

        for (s in satellites)
        {
            if (tower != null && s == tower)
                continue;

            range = (tower != null && tower.isSatellite ()) ? Math.max (s.range, tower.range) : s.range;
            xdif = x - s.x;
            ydif = y - s.y;
            dist = xdif * xdif + ydif * ydif;

            if (dist <= range * range)
                return true;
        }

        return false;
    }

    /**
     * Add a new satellite if it's inside range
     * @param   satellite   satellite to add
     * @param   force   force insertion
     * @return  if satellite was added
     */
    public function add (satellite : Tower, force : Bool = false) : Bool
    {
        if (force || isPointInside (satellite.x, satellite.y, satellite))
        {
            this.satellites.push (satellite);
            return true;
        }

        return false;
    }

    public function addSatellites (s : Array<Tower>) : Void
    {
        var added = true, l;
        var sAux = s.copy ();
        while (added) {
            l = sAux.length;
            sAux = sAux.filter (function (elem) {
                return !add (elem);
            });

            added = sAux.length < l;
        }
    }

    public function remove (satellite : Tower) : Void
    {
        this.satellites.remove (satellite);
    }

    public function contains (satellite : Tower) : Bool
    {
        return this.satellites.indexOf (satellite) >= 0;
    }

    public function length () : Int
    {
        return this.satellites.length;
    }
}

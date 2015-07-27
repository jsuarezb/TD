package td.util;

import haxe.ds.ObjectMap;

import td.entity.tower.*;

class EnergyRange
{

    private var base : Base;

    private var satellites : Array<Tower>;

    private var satellitesWithEnergy : Array<Tower>;

    /**
     * EnergyRange constructor
     * @param   base    base of the energy
     */
    public function new (base : Base)
    {
        this.base = base;
        this.satellites = new Array<Tower> ();
        this.satellites.push (this.base);
        this.satellitesWithEnergy = new Array<Tower> ();
    }

    /**
     * Add a satellite
     * @param   tower   satellite tower
     */
    public function push (tower : Tower) : Void
    {
        satellites.push (tower);
    }

    /**
     * Return if specified point is inside the range of at least one powered
     * satellite
     * @param   x   x coordinate
     * @param   y   y coordinate
     * @param   [tower] specify satellite
     */
    public function isPointInside (x : Float, y : Float, ?tower : Tower) : Bool
    {
        var range, xdif, ydif, dist;

        for (s in satellitesWithEnergy)
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
    private function add (satellite : Tower) : Bool
    {
        if (isPointInside (satellite.x, satellite.y, satellite))
        {
            satellitesWithEnergy.push (satellite);
            return true;
        }

        return false;
    }

    /**
     * Determine the satellites that are powered
     */
    public function generate () : Void
    {
        var added = true, l;
        var sAux = satellites.copy ();
        satellitesWithEnergy = new Array<Tower> ();
        satellitesWithEnergy.push (base);

        // The algorithm tries to add every tower inside sAux to
        // satellitesWithEnergy by filtering sAux using the negated add function
        // Whenever sAux remains the same after the filter, the algorithm ends
        while (added) {
            l = sAux.length;
            sAux = sAux.filter (function (elem) {
                return !add (elem);
            });

            added = sAux.length < l;
        }
    }

    /**
     * Show powered satellites range
     */
    public function showRange () : Void
    {
        for (t in satellitesWithEnergy)
            t.showRange ();
    }

}

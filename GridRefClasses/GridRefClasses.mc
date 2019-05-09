//!
//! Copyright 2015 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.Math;

/* Based on geodesy source downloaded from : https://github.com/chrisveness/geodesy               */
/* and : https://www.movable-type.co.uk/scripts/latlong-os-gridref.html                           */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */
/* Ordnance Survey Grid Reference functions                           (c) Chris Veness 2005-2017  */
/*                                                                                   MIT Licence  */
/* www.movable-type.co.uk/scripts/latlong-gridref.html                                            */
/* www.movable-type.co.uk/scripts/geodesy/docs/module-osgridref.html                              */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */

/**
 * Ellipsoid parameters; major axis (a), minor axis (b), and flattening (f) for each ellipsoid.
LatLon.ellipsoid = {
    WGS84:         { a: 6378137,     b: 6356752.314245, f: 1/298.257223563 },
    Airy1830:      { a: 6377563.396, b: 6356256.909,    f: 1/299.3249646   },
};
/**
 * Datums; with associated ellipsoid, and Helmert transform parameters to convert from WGS 84 into
 * given datum.
 *
 * Note that precision of various datums will vary, and WGS-84 (original) is not defined to be
 * accurate to better than ±1 metre. No transformation should be assumed to be accurate to better
 * than a metre; for many datums somewhat less.
LatLon.datum = {
    // transforms: t in metres, s in ppm, r in arcseconds                    tx       ty        tz       s        rx       ry       rz
    OSGB36:     { ellipsoid: LatLon.ellipsoid.Airy1830,      transform: [ -446.448, 125.157, -542.060,  20.4894, -0.1502, -0.2470, -0.8421 ] },
    WGS84:      { ellipsoid: LatLon.ellipsoid.WGS84,         transform: [    0.0,     0.0,      0.0,     0.0,     0.0,     0.0,     0.0    ] },
};
*/

/*
class OSLocation {
	protected var latitude;
	protected var longitude;
	
	function initialize(coords) {
    	self.latitude = coords[0];
    	self.longitude = coords[1];
    }
    
    function toRadians() {
    	var la, lo;
    	if (self.format == :degrees) {
    	  self.latitude = Math.toRadians(self.latitude);
    	  self.longitude = Math.toRadians(self.longitude);
	    }
	    return [self.latitude, self.longitude];
	}
}
*/

module GridRefClasses {

class Vector3d {
	protected var x;
	protected var y;
	protected var z;
	
	function initialize(x, y, z) {
    	self.x = x.toDouble();
    	self.y = y.toDouble();
    	self.z = z.toDouble();
    }
    
/**
 * Applies Helmert transform to the ‘me’ point using transform parameters t.
 *
 * @private
 * @param   {number[]} t - Transform to apply to this point.
 * @returns {Vector3} Transformed point.
 */
//* transform 't' fixed to OSGB36
	 function applyTransform ()   {
    	// this point
    	var x1 = self.x, y1 = self.y, z1 = self.z;
    	
    // transform parameters
	    var tx = -446.448;                    // x-shift
	    var ty = 125.157;                    // y-shift
	    var tz = -542.060;                    // z-shift
	    var s1 = 20.4894/1e6 + 1;            // scale: normalise parts-per-million to (s+1)
	    var rx = Math.toRadians(-0.1502/3600); // x-rotation: normalise arcseconds to radians
	    var ry = Math.toRadians(-0.2470/3600); // y-rotation: normalise arcseconds to radians
	    var rz = Math.toRadians(-0.8421/3600); // z-rotation: normalise arcseconds to radians

	    // apply transform
    	var x2 = tx + x1*s1 - y1*rz + z1*ry;
    	var y2 = ty + x1*rz + y1*s1 - z1*rx;
    	var z2 = tz - x1*ry + y1*rx + z1*s1;
    	
	    return new Vector3d (x2, y2, z2);
	}

/**
 * Converts ‘me’ (geocentric) cartesian (x/y/z) point to (ellipsoidal geodetic) latitude/longitude
 * coordinates on specified datum.
 *
 * Uses Bowring's (1985) formulation for μm precision in concise form.
 *
 * @param {LatLon.datum.transform} datum - Datum to use when converting point.
 */
//:a => 6377563.396, :b => 6356256.909,    :f1 => 299324964, :f2 => 0.6,   :f3 => 1000000
// assumes OSGB36
	function toLatLonE() {
    	var x = self.x, y = self.y, z = self.z;
    	var a = 6377563.396d;
    	var b = 6356256.909d;
    	var f = 1 / 299.3249646d;
    	
	    var e2 = 2*f - f*f;   // 1st eccentricity squared ≡ (a²-b²)/a²
	    var ε2 = e2 / (1-e2); // 2nd eccentricity squared ≡ (a²-b²)/b²
	    var p = Math.sqrt(x*x + y*y); // distance from minor axis
	    var R = Math.sqrt(p*p + z*z); // polar radius

	    // parametric latitude (Bowring eqn 17, replacing tanβ = z·a / p·b)
	    var tanβ = (b*z)/(a*p) * (1+ε2*b/R);
        var sinβ = tanβ / Math.sqrt(1+tanβ*tanβ);
    	var cosβ = sinβ / tanβ;
   		var φ = (cosβ != cosβ) ? 0 : Math.atan2(z + ε2*b*sinβ*sinβ*sinβ, p - e2*a*cosβ*cosβ*cosβ);

	    // longitude
	    var λ = Math.atan2(y, x);

		var location = [φ, λ];
    	return location;
	}
}
	
class LatLon {
	protected var loc;

	function initialize(location) {
    	self.loc = location;
    }

// only transforms from WGS84 to OSGB36
// other possibilities removed
    function convertDatum () {
		var cartesian = self.toCartesian();           // convert polar to cartesian...
	  	    cartesian = cartesian.applyTransform();   // ...apply transform...
    		return cartesian.toLatLonE();        // ...and convert cartesian to polar
    }
    
/**
 * Converts ‘me’ point from (geodetic) latitude/longitude coordinates to (geocentric) cartesian
 * (x/y/z) coordinates.
 *
 * @returns {Vector3d} Vector pointing to lat/lon point, with x, y, z in metres from earth centre.
 */
 // NB assumes WGS84
	function toCartesian() {
	    var φ = self.loc[0]; // lat
    	var λ = self.loc[1]; // lon
//    	var h = 0; // height above ellipsoid - not currently used
    	var a  = 6378137;
    	var f1 = 298257223;
    	var f = 1 / 298.257223563d;

    	var sinφ = Math.sin(φ), cosφ = Math.cos(φ);
    	var sinλ = Math.sin(λ), cosλ = Math.cos(λ);

    	var eSq = 2*f - f*f;                      // 1st eccentricity squared ≡ (a²-b²)/a²
    	var ν = a / Math.sqrt(1 - eSq*sinφ*sinφ); // radius of curvature in prime vertical

/*
	    var x = (ν+h) * cosφ * cosλ;
	    var y = (ν+h) * cosφ * sinλ;
	    var z = (ν*(1-eSq)+h) * sinφ;
*/
	    var x = (ν) * cosφ * cosλ;
	    var y = (ν) * cosφ * sinλ;
	    var z = (ν*(1-eSq)) * sinφ;

    	var point = new Vector3d(x, y, z);
    	return point;
	}
}

class OsGridRef {
	protected var easting;
	protected var northing;
	
	function initialize(east, north) {
	    self.easting = east;
	    self.northing = north;
	}

/**
 * Converts ‘me’ numeric grid reference to standard OS grid reference.
 *
 * @param   {number} [digits=10] - Precision of returned grid reference (10 digits = metres);
 * @returns {string} This grid reference in standard format.
 *
 * @example
 *   var ref = new (651409, 313177).toString(); // TG 51409 13177
 */
    const cDigits = 6;
 
	function toString (digits) {
	    var e = self.easting;
	    var n = self.northing;
	    
	    digits = (digits == null) ? 6 : digits.toNumber();
		if (digits%2!=0 || digits<4 || digits>10) {
	    	digits = cDigits;
	    }

	    // get the 100km-grid indices
	    var e100k = Math.floor(e/100000), n100k = Math.floor(n/100000);

	    if (e100k<0 || e100k>6 || n100k<0 || n100k>12) {return "Outside Grid";}

	    // translate those into numeric equivalents of the grid letters
	    var l1 = (19-n100k) - (19-n100k)%5 + Math.floor((e100k+10)/5);
	    var l2 = (19-n100k)*5%25 + e100k%5;

	    // compensate for skipped 'I' and build grid letter-pairs
    	if (l1 > 7) {l1++;}
    	if (l2 > 7) {l2++;}
//    	var letterPair = String.fromCharCode(l1+'A'.charCodeAt(0), l2+'A'.charCodeAt(0));
//		var letterPair = ((l1 + 'A'.toNumber()).toChar()).toString() + ((l2 + 'A'.toNumber()).toChar()).toString();
		// there _must_ be a better way...
		var A = 'A'.toNumber();
		var letterPair = ((l1+A).toChar()).toString() + ((l2+A).toChar()).toString();
		
	    // strip 100km-grid indices from easting & northing, and reduce precision
	    e = Math.floor((e%100000)/Math.pow(10, 5-digits/2)).toNumber();
	    n = Math.floor((n%100000)/Math.pow(10, 5-digits/2)).toNumber();
	    
	    // pad eastings & northings with leading zeros (just in case, allow up to 16-digit (mm) refs)
	    e = ("00000000"+e);
		e = e.substring((e.length() - digits/2), e.length());
	    n = ("00000000"+n);
		n = n.substring((n.length() - digits/2), n.length());

	    return letterPair + " " + e + " " + n;
	}
}

	function latLonToOsGrid  (point) {
	    // convert to OSGB36 first
    	var radians = point.convertDatum();

    	var φ = radians[0];
    	var λ = radians[1];

	    var a = 6377563.396, b = 6356256.909;              // Airy 1830 major & minor semi-axes
	    var F0 = 0.9996012717;                             // NatGrid scale factor on central meridian
	    var φ0 = Math.toRadians(49), λ0 = Math.toRadians(-2);  // NatGrid true origin is 49°N,2°W
	    var N0 = -100000, E0 = 400000;                     // northing & easting of true origin, metres
	    var e2 = 1 - (b*b)/(a*a);                          // eccentricity squared
	    var n = (a-b)/(a+b), n2 = n*n, n3 = n*n*n;         // n, n², n³

    	var cosφ = Math.cos(φ), sinφ = Math.sin(φ);
    	var ν = a*F0/Math.sqrt(1-e2*sinφ*sinφ);            // nu = transverse radius of curvature
    	var ρ = a*F0*(1-e2)/Math.pow(1-e2*sinφ*sinφ, 1.5); // rho = meridional radius of curvature
    	var η2 = ν/ρ-1;                                    // eta = ?

    	var Ma = (1 + n + (5/4)*n2 + (5/4)*n3) * (φ-φ0);
    	var Mb = (3*n + 3*n*n + (21/8)*n3) * Math.sin(φ-φ0) * Math.cos(φ+φ0);
    	var Mc = ((15/8)*n2 + (15/8)*n3) * Math.sin(2*(φ-φ0)) * Math.cos(2*(φ+φ0));
    	var Md = (35/24)*n3 * Math.sin(3*(φ-φ0)) * Math.cos(3*(φ+φ0));
    	var M = b * F0 * (Ma - Mb + Mc - Md);              // meridional arc

	    var cos3φ = cosφ*cosφ*cosφ;
	    var cos5φ = cos3φ*cosφ*cosφ;
	    var tan2φ = Math.tan(φ)*Math.tan(φ);
	    var tan4φ = tan2φ*tan2φ;

	    var I = M + N0;
	    var II = (ν/2)*sinφ*cosφ;
	    var III = (ν/24)*sinφ*cos3φ*(5-tan2φ+9*η2);
	    var IIIA = (ν/720)*sinφ*cos5φ*(61-58*tan2φ+tan4φ);
	    var IV = ν*cosφ;
	    var V = (ν/6)*cos3φ*(ν/ρ-tan2φ);
	    var VI = (ν/120) * cos5φ * (5 - 18*tan2φ + tan4φ + 14*η2 - 58*tan2φ*η2);

	    var Δλ = λ-λ0;
	    var Δλ2 = Δλ*Δλ, Δλ3 = Δλ2*Δλ, Δλ4 = Δλ3*Δλ, Δλ5 = Δλ4*Δλ, Δλ6 = Δλ5*Δλ;

	    var N = I + II*Δλ2 + III*Δλ4 + IIIA*Δλ6;
	    var E = E0 + IV*Δλ + V*Δλ3 + VI*Δλ5;

		N = N.toNumber();
		E = E.toNumber();
	    
	    return new OsGridRef(E, N);
	}

        // Return the Grid Ref of latitude/longitude "position" as a string
    function OSGridString(position, digits) {
		//return (latLonToOsGrid(new LatLon(position))).toString();
		var latlon = new LatLon(position);
		var osgrid = latLonToOsGrid(latlon);
		return osgrid.toString(digits);
    }
}

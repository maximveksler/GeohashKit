//
//  Geohash.swift
//  GeohashKit
//
//  Created by David Troy on 30/5/08 https://github.com/davetroy/geohash-js/blob/master/geohash.js
//  Created by Maxim Veksler on 5/4/15.
//
//  (c) 2015 Maxim Veksler.
//  Distributed under the MIT License
//

enum CompassPoint {
    case North // Top
    case South // Bottom
    case East // Right
    case West  // Left
}

enum Parity { case Even, Odd }
prefix func !(a: Parity) -> Parity {
    return a == .Even ? .Odd : .Even
}

let BASE32 = Array("0123456789bcdefghjkmnpqrstuvwxyz") // decimal to 32base mapping (1 => 1, 23 => r, 31 => z)

let NEIGHBORS : [CompassPoint : [Parity : String]] = [
    .East  : [ .Even   : "bc01fg45238967deuvhjyznpkmstqrwx" ],
    .East  : [ .Odd    : "p0r21436x8zb9dcf5h7kjnmqesgutwvy" ],
    .West  : [ .Even   : "238967debc01fg45kmstqrwxuvhjyznp" ],
    .West  : [ .Odd    : "14365h7k9dcfesgujnmqp0r2twvyx8zb" ],
    .North : [ .Even   : "p0r21436x8zb9dcf5h7kjnmqesgutwvy" ],
    .North : [ .Odd    : "bc01fg45238967deuvhjyznpkmstqrwx" ],
    .South : [ .Even   : "14365h7k9dcfesgujnmqp0r2twvyx8zb" ],
    .South : [ .Odd    : "238967debc01fg45kmstqrwxuvhjyznp" ]
]

let BORDERS : [CompassPoint : [Parity : String]] = [
    .East  : [ .Even   : "bcfguvyz" ],
    .East  : [ .Odd    : "prxz" ],
    .West  : [ .Even   : "0145hjnp" ],
    .West  : [ .Odd    : "028b" ],
    .North : [ .Even   : "prxz" ],
    .North : [ .Odd    : "bcfguvyz" ],
    .South : [ .Even   : "028b" ],
    .South : [ .Odd    : "0145hjnp" ]
]

public class Geohash {
    public static func encodeGeoHash(#latitude: Double, longitude: Double, _ precision: Int? = Optional.None) -> String {
        var lat = (-90.0, 90.0)
        var lon = (-180.0, 180.0)
        
        // to be generated result.
        var geohash = String()
        
        // Loop helpers
        var parity_mode = Parity.Even;
        var base32char = 0
        var bit = 0b10000
        
        do {
            switch (parity_mode) {
            case .Even:
                let mid = (lon.0 + lon.1) / 2
                if(longitude >= mid) {
                    base32char |= bit
                    lon.0 = mid;
                } else {
                    lon.1 = mid;
                }
            case .Odd:
                let mid = (lat.0 + lat.1) / 2
                if(latitude >= mid) {
                    base32char |= bit
                    lat.0 = mid;
                } else {
                    lat.1 = mid;
                }
            }
            
            // Flip between Even and Odd
            parity_mode = !parity_mode
            // And shift to next bit 
            bit >>= 1

            if(bit == 0b00000) {
                geohash += String(BASE32[base32char])
                bit = 0b10000 // set next character round.
                base32char = 0
            }
            
        } while precision != nil ?
            count(geohash) < precision : // Either precision is specified
            bit != 0b10000 || (lat.1 - lat.0 > 0.05) || (lon.1 - lon.0 > 0.05) // or we use sane defaults
        
        return geohash
    }
}
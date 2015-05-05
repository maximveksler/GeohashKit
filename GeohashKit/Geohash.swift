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

let BITS = [16, 8, 4, 2, 1]
let BASE32 = Array("0123456789bcdefghjkmnpqrstuvwxyz")

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
    public static func encodeGeoHash(latitude: Double, longitude: Double, precision: Int = 12) -> String {
        var lat = (-90.0, 90.0)
        var lon = (-180.0, 180.0)
        
        // to be generated result.
        var geohash = String()
        
        // Loop helpers
        var __mode_bit = Parity.Even;
        var ch = 0
        var bit = 0
        
        while(count(geohash) < precision) {
            switch (__mode_bit) {
            case .Even:
                let mid = (lon.0 + lon.1) / 2
                if(longitude > mid) {
                    ch |= BITS[bit]
                    lon.0 = mid;
                } else {
                    lon.1 = mid;
                }
            case .Odd:
                let mid = (lat.0 + lat.1) / 2
                if(latitude > mid) {
                    ch |= BITS[bit]
                    lat.0 = mid;
                } else {
                    lat.1 = mid;
                }
            }
            
            // Flip between Even and Odd
            __mode_bit = !__mode_bit
            
            if(bit < 4) {
                bit++
            } else {
                geohash += String(BASE32[ch])
                bit = 0
                ch = 0
            }
        }
        
        return geohash
    }
}
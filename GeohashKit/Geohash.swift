//
//  Geohash.swift
//  GeohashKit
//
//  Created by Maxim Veksler on 5/4/15.
//  Based on work done by David Troy https://github.com/davetroy/geohash-js/blob/master/geohash.js
//
//  (c) 2015 Maxim Veksler.
//  Distributed under the MIT License
//

public class Geohash {
    // - MARK: Public
    public static func encode(latitude latitude: Double, longitude: Double, _ precision: Int? = nil) -> String {
        return geohashbox(latitude: latitude, longitude: longitude, precision)!.hash
    }
    
    public static func decode(hash: String) -> (latitude: Double, longitude: Double)? {
        return geohashbox(hash)?.point
    }
    
    public static func neighbors(centerHash: String) -> [String]? {
        // neighbor precision *must* be them same as center'ed bounding box.
        let precision = centerHash.characters.count
        
        if let box = geohashbox(centerHash) {
            let n = neighbor(box, direction: .North, precision: precision) // n
            let s = neighbor(box, direction: .South, precision: precision) // s
            let e = neighbor(box, direction: .East, precision: precision)  // e
            let w = neighbor(box, direction: .West, precision: precision)  // w
            let ne = neighbor(n, direction: .East, precision: precision)   // ne
            let nw = neighbor(n, direction: .West, precision: precision)   // nw
            let se = neighbor(s, direction: .East, precision: precision)   // se
            let sw = neighbor(s, direction: .West, precision: precision)   // sw

            // in clockwise order
            return [n!.hash, ne!.hash, e!.hash, se!.hash, s!.hash, sw!.hash, w!.hash, nw!.hash]
        } else {
            return nil
        }
    }
    
    // - MARK: Private
    static func geohashbox(latitude latitude: Double, longitude: Double, var _ precision: Int? = nil) -> GeohashBox? {
        var lat = (-90.0, 90.0)
        var lon = (-180.0, 180.0)
        
        // to be generated result.
        var geohash = String()
        
        // Loop helpers
        var parity_mode = Parity.Even;
        var base32char = 0
        var bit = BASE32_BITFLOW_INIT
        
        // Set precision to 5 if not specified.
        if precision == nil {
            precision = 5
        }
        
        repeat {
            switch (parity_mode) {
            case .Even:
                let mid = (lon.0 + lon.1) / 2
                if(longitude >= mid) {
                    base32char |= Int(bit)
                    lon.0 = mid;
                } else {
                    lon.1 = mid;
                }
            case .Odd:
                let mid = (lat.0 + lat.1) / 2
                if(latitude >= mid) {
                    base32char |= Int(bit)
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
                bit = BASE32_BITFLOW_INIT // set next character round.
                base32char = 0
            }
            
        } while geohash.characters.count < precision
        
        return GeohashBox(hash: geohash, north: lat.1, west: lon.0, south: lat.0, east: lon.1)
    }
    
    static func geohashbox(hash: String) -> GeohashBox? {
        var parity_mode = Parity.Even;
        var lat = (-90.0, 90.0)
        var lon = (-180.0, 180.0)
        
        for c in hash.characters {
            let bitmap = BASE32.indexOf(c)
            
            if let bitmap = bitmap {
                for var mask = Int(BASE32_BITFLOW_INIT); mask != 0; mask >>= 1 {
                    switch (parity_mode) {
                    case .Even:
                        if(bitmap & mask != 0) {
                            lon.0 = (lon.0 + lon.1) / 2
                        } else {
                            lon.1 = (lon.0 + lon.1) / 2
                        }
                    case .Odd:
                        if(bitmap & mask != 0) {
                            lat.0 = (lat.0 + lat.1) / 2
                        } else {
                            lat.1 = (lat.0 + lat.1) / 2
                        }
                    }
                    
                    parity_mode = !parity_mode
                }
            } else {
                // Break on non geohash code char.
                return nil
            }
        }

        return GeohashBox(hash: hash, north: lat.1, west: lon.0, south: lat.0, east: lon.1)
    }
    
    static func neighbor(box: GeohashBox?, direction: CompassPoint, precision: Int) -> GeohashBox? {
        if let box = box {
            switch (direction) {
            case .North:
                let new_latitude = box.point.latitude + box.size.latitude // North is upper in the latitude scale
                return geohashbox(latitude: new_latitude, longitude: box.point.longitude, precision)
            case .South:
                let new_latitude = box.point.latitude - box.size.latitude // South is lower in the latitude scale
                return geohashbox(latitude: new_latitude, longitude: box.point.longitude, precision)
            case .East:
                let new_longitude = box.point.longitude + box.size.longitude // East is bigger in the longitude scale
                return geohashbox(latitude: box.point.latitude, longitude: new_longitude, precision)
            case .West:
                let new_longitude = box.point.longitude - box.size.longitude // West is lower in the longitude scale
                return geohashbox(latitude: box.point.latitude, longitude: new_longitude, precision)
            }
        } else {
            return nil
        }
    }
    
}

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

let BASE32 = Array("0123456789bcdefghjkmnpqrstuvwxyz".characters) // decimal to 32base mapping (0 => "0", 31 => "z")
let BASE32_BITFLOW_INIT :UInt8 = 0b10000
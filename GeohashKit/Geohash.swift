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

enum CompassPoint {
    case north // Top
    case south // Bottom
    case east // Right
    case west  // Left
}

enum Parity {
    case even, odd
}

prefix func !(a: Parity) -> Parity {
    return a == .even ? .odd : .even
}

public struct Geohash {
    public static let defaultPrecision = 5
    
    private static let DecimalToBase32Map = Array("0123456789bcdefghjkmnpqrstuvwxyz") // decimal to 32base mapping (0 => "0", 31 => "z")
    private static let Base32BitflowInit: UInt8 = 0b10000

    // - MARK: Public
    public static func encode(latitude: Double, longitude: Double, _ precision: Int = Geohash.defaultPrecision) -> String {
        return geohashbox(latitude: latitude, longitude: longitude, precision)!.hash
    }
    
    public static func decode(_ hash: String) -> (latitude: Double, longitude: Double)? {
        return geohashbox(hash)?.point
    }
    
    public static func neighbors(_ centerHash: String) -> [String]? {
        // neighbor precision *must* be them same as center'ed bounding box.
        let precision = centerHash.count
        
        guard let box = geohashbox(centerHash),
            let n = neighbor(box, direction: .north, precision: precision), // n
            let s = neighbor(box, direction: .south, precision: precision), // s
            let e = neighbor(box, direction: .east, precision: precision),  // e
            let w = neighbor(box, direction: .west, precision: precision),  // w
            let ne = neighbor(n, direction: .east, precision: precision),   // ne
            let nw = neighbor(n, direction: .west, precision: precision),   // nw
            let se = neighbor(s, direction: .east, precision: precision),   // se
            let sw = neighbor(s, direction: .west, precision: precision)   // sw
            else { return nil }

        // in clockwise order
        return [n.hash, ne.hash, e.hash, se.hash, s.hash, sw.hash, w.hash, nw.hash]
    }
    
    // - MARK: Private
    static func geohashbox(latitude: Double, longitude: Double, _ precision: Int = Geohash.defaultPrecision) -> GeohashBox? {
        var lat = (-90.0, 90.0)
        var lon = (-180.0, 180.0)
        
        // to be generated result.
        var geohash = String()
        
        // Loop helpers
        var parity_mode = Parity.even;
        var base32char = 0
        var bit = Base32BitflowInit
        
        repeat {
            switch (parity_mode) {
            case .even:
                let mid = (lon.0 + lon.1) / 2
                if(longitude >= mid) {
                    base32char |= Int(bit)
                    lon.0 = mid;
                } else {
                    lon.1 = mid;
                }
            case .odd:
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
                geohash += String(DecimalToBase32Map[base32char])
                bit = Base32BitflowInit // set next character round.
                base32char = 0
            }
            
        } while geohash.count < precision
        
        return GeohashBox(hash: geohash, north: lat.1, west: lon.0, south: lat.0, east: lon.1)
    }
    
    static func geohashbox(_ hash: String) -> GeohashBox? {
        var parity_mode = Parity.even;
        var lat = (-90.0, 90.0)
        var lon = (-180.0, 180.0)
        
        for c in hash {
            guard let bitmap = DecimalToBase32Map.index(of: c) else {
                // Break on non geohash code char.
                return nil
            }

            var mask = Int(Base32BitflowInit)
            while mask != 0 {

                switch (parity_mode) {
                case .even:
                    if(bitmap & mask != 0) {
                        lon.0 = (lon.0 + lon.1) / 2
                    } else {
                        lon.1 = (lon.0 + lon.1) / 2
                    }
                case .odd:
                    if(bitmap & mask != 0) {
                        lat.0 = (lat.0 + lat.1) / 2
                    } else {
                        lat.1 = (lat.0 + lat.1) / 2
                    }
                }

                parity_mode = !parity_mode
                mask >>= 1
            }
        }

        return GeohashBox(hash: hash, north: lat.1, west: lon.0, south: lat.0, east: lon.1)
    }
    
    static func neighbor(_ box: GeohashBox?, direction: CompassPoint, precision: Int) -> GeohashBox? {
        guard let box = box else { return nil }

        switch (direction) {
        case .north:
            let new_latitude = box.point.latitude + box.size.latitude // North is upper in the latitude scale
            return geohashbox(latitude: new_latitude, longitude: box.point.longitude, precision)
        case .south:
            let new_latitude = box.point.latitude - box.size.latitude // South is lower in the latitude scale
            return geohashbox(latitude: new_latitude, longitude: box.point.longitude, precision)
        case .east:
            let new_longitude = box.point.longitude + box.size.longitude // East is bigger in the longitude scale
            return geohashbox(latitude: box.point.latitude, longitude: new_longitude, precision)
        case .west:
            let new_longitude = box.point.longitude - box.size.longitude // West is lower in the longitude scale
            return geohashbox(latitude: box.point.latitude, longitude: new_longitude, precision)
        }
    }

}

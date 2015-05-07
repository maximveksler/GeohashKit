//
//  GeohashTests.swift
//  GeohashKit
//
//  Tested are based on https://github.com/vyshane/geohash-tool/tree/master/Geohash%20Tool
//
//  Created by Maxim Veksler on 5/5/15.
//  (c) 2015 Maxim Veksler.
//

import XCTest
import GeohashKit

class GeohashTests: XCTestCase {
    func testEncode() {
        // geohash.org
        XCTAssertEqual(Geohash.encodeGeoHash(latitude: -25.383, longitude: -49.266, 8), "6gkzwgjt")
        XCTAssertEqual(Geohash.encodeGeoHash(latitude: -25.382708, longitude: -49.265506, 12), "6gkzwgjzn820")
        XCTAssertEqual(Geohash.encodeGeoHash(latitude: -25.427, longitude: -49.315, 8), "6gkzmg1u")

        // Geohash Tool
        XCTAssertEqual(Geohash.encodeGeoHash(latitude: -31.953, longitude: 115.857, 8), "qd66hrhk")
        XCTAssertEqual(Geohash.encodeGeoHash(latitude: 38.89710201881826, longitude: -77.03669792041183, 12), "dqcjqcp84c6e")
        
        // Narrow samples.
        XCTAssertEqual(Geohash.encodeGeoHash(latitude: 42.6, longitude: -5.6, 5), "ezs42")
    }
    
    func testEncodeDefaultPrecision() {
        // Narrow samples.
        XCTAssertEqual(Geohash.encodeGeoHash(latitude: 42.6, longitude: -5.6), "ezs42")
        XCTAssertEqual(Geohash.encodeGeoHash(latitude: 0, longitude: 0), "s000")
    }

}



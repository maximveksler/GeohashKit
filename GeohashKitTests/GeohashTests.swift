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
        XCTAssertEqual(Geohash.encodeGeoHash(-31.953, longitude: 115.857, precision: 8), "qd66hrhk")
        XCTAssertEqual(Geohash.encodeGeoHash(38.89710201881826, longitude: -77.03669792041183, precision: 12), "dqcjqcp84c6e")
    }
}



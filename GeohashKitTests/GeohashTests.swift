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
    // - MARK: encode
    func testEncode() {
        // geohash.org
        XCTAssertEqual(Geohash.encode(latitude: -25.383, longitude: -49.266, 8), "6gkzwgjt")
        XCTAssertEqual(Geohash.encode(latitude: -25.382708, longitude: -49.265506, 12), "6gkzwgjzn820")
        XCTAssertEqual(Geohash.encode(latitude: -25.427, longitude: -49.315, 8), "6gkzmg1u")
        
        // Geohash Tool
        XCTAssertEqual(Geohash.encode(latitude: -31.953, longitude: 115.857, 8), "qd66hrhk")
        XCTAssertEqual(Geohash.encode(latitude: 38.89710201881826, longitude: -77.03669792041183, 12), "dqcjqcp84c6e")
        
        // Narrow samples.
        XCTAssertEqual(Geohash.encode(latitude: 42.6, longitude: -5.6, 5), "ezs42")
    }
    
    func testEncodeDefaultPrecision() {
        // Narrow samples.
        XCTAssertEqual(Geohash.encode(latitude: 42.6, longitude: -5.6), "ezs42")
        
        // XCTAssertEqual(Geohash.encode(latitude: 0, longitude: 0), "s000") // => "s0000" :( hopefully will be resovled by #Issue:1
    }
    
    // - MARK: decode
    func aDecodeUnitTest(hash: String, _ expectedLatitude: Double, _ expectedLongitude: Double) {
        let point = Geohash.decode(hash);
        
        XCTAssertEqualWithAccuracy(point!.latitude, expectedLatitude, Double(FLT_EPSILON))
        XCTAssertEqualWithAccuracy(point!.longitude, expectedLongitude, Double(FLT_EPSILON))
    }

    func testDecode() {
        aDecodeUnitTest("ezs42", 42.60498046875, -5.60302734375)
        aDecodeUnitTest("spey61y", 43.296432495117, 5.3702545166016)
    }
    
    

}



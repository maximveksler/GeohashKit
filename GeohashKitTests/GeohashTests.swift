//
//  GeohashTests.swift
//  GeohashKit
//
//  Tested are based on https://github.com/vyshane/geohash-tool/tree/master/Geohash%20Tool
//
//  useful toolkit: 
//   * http://gmaps-samples.googlecode.com/svn/trunk/geocoder/singlegeocode.html
//   * http://geohash.org
//   * http://geohash.gofreerange.com
//   * http://www.movable-type.co.uk/scripts/geohash.html
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
    /// Testing latitude & longitude decode correctness, with epsilon precision.
    func aDecodeUnitTest(hash: String, _ expectedLatitude: Double, _ expectedLongitude: Double) {
        let (latitude, longitude) = Geohash.decode(hash)!;
        
        XCTAssertEqualWithAccuracy(latitude, expectedLatitude, accuracy: Double(FLT_EPSILON))
        XCTAssertEqualWithAccuracy(longitude, expectedLongitude, accuracy: Double(FLT_EPSILON))
    }

    func testDecode() {
        aDecodeUnitTest("ezs42", 42.60498046875, -5.60302734375)
        aDecodeUnitTest("spey61y", 43.296432495117, 5.3702545166016)
    }
    
    // - MARK: neighbors
    func testNeighbors() {
        // Bugrashov, Tel Aviv, Israel
        XCTAssertEqual(["sv8wrqfq", "sv8wrqfw", "sv8wrqft", "sv8wrqfs", "sv8wrqfk", "sv8wrqfh", "sv8wrqfj", "sv8wrqfn"], Geohash.neighbors("sv8wrqfm")!)
        // Meridian Gardens
        XCTAssertEqual(["gcpvpbpbp", "u10j00000", "u10hbpbpb", "u10hbpbp8", "gcpuzzzzx", "gcpuzzzzw", "gcpuzzzzy", "gcpvpbpbn"], Geohash.neighbors("gcpuzzzzz")!)
        // Overkills are fun!
        XCTAssertEqual(["cbsuv7ztq4345234323d", "cbsuv7ztq4345234323f", "cbsuv7ztq4345234323c", "cbsuv7ztq4345234323b", "cbsuv7ztq43452343238", "cbsuv7ztq43452343232", "cbsuv7ztq43452343233", "cbsuv7ztq43452343236"], Geohash.neighbors("cbsuv7ztq43452343239")!)
        // France
        XCTAssertEqual(["u001", "u003", "u002", "spbr", "spbp", "ezzz", "gbpb", "gbpc"], Geohash.neighbors("u000")!)
    }
}



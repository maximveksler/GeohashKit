//
//  GeohashBox.swift
//  GeohashKit
//
//  Created by Maxim Veksler on 5/10/15.
//  Copyright (c) 2015 Maxim Veksler. All rights reserved.
//

struct GeohashBox {
    let north :Double // top
    let south: Double // bottom
    let west: Double // left
    let east: Double // right

    func point() -> (latitude: Double, longitude: Double) {
        return (latitude: (self.north + self.south) / 2, longitude: (self.east + self.west) / 2)
    }
}

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)

# GeohashKit 

GeohashKit is a native Swift implementation of the [geohash](http://en.wikipedia.org/wiki/Geohash) hashing algorithem. Supporting encode, decode and neighbor search.

## API

### Encode
```swift
Geohash.encode(latitude: 42.6, longitude: -5.6) // "ezs42"
```

###### Specify desired precision
```swift
Geohash.encode(latitude: -25.382708, longitude: -49.265506, 12) // "6gkzwgjzn820"
```

### Decode
```swift
Geohash.decode("ezs42")! // (latitude: 42.60498046875, longitude: -5.60302734375)
```

### Neighbor Search
```swift
Geohash.neighbors("u000")! // ["u001", "u003", "u002", "spbr", "spbp", "ezzz", "gbpb", "gbpc"]
```

## Install
GeohashKit is distribured with [Carthage](https://github.com/Carthage/Carthage).

  1. Add ```github "maximveksler/GeohashKit"``` to your ```Cartfile```
  2. Run ```carthage update --use-submodules``` to build the Framework
  3. Drag *GeohashKit* into XCode's *Embedded Binaries* section

## License
Copyright (c) 2015 - Maxim Veksler   
Released under the MIT License (MIT)

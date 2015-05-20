[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)

# GeohashKit 

GeohashKit is a native Swift implementation of the geohash protocol. Encode, decode and dynamic bounding box neighbor search is implemented. Much consideration went to design an API that allows wonderfully simple work flow.

## API
### Decode
```swift
Geohash.decode("ezs42")! // (latitude: 42.60498046875, longitude: -5.60302734375)
```

### Neighbors
```swift
Geohash.neighbors("u000")! // ["u001", "u003", "u002", "spbr", "spbp", "ezzz", "gbpb", "gbpc"]
```

### Encode
```swift
Geohash.encode(latitude: 42.6, longitude: -5.6) // "ezs42"
```

###### Specify desired precision
```swift
Geohash.encode(latitude: -25.382708, longitude: -49.265506, 12) // "6gkzwgjzn820"
```

## Install
GeohashKit is distribured with [Carthage](https://github.com/Carthage/Carthage).

Add ```github "maximveksler/GeohashKit"``` to your ```Cartfile```

## Author
The MIT License (MIT)  
Copyright (c) 2015 - [Maxim Veksler](maxim@vekslers.org)

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)

# GeohashKit 

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


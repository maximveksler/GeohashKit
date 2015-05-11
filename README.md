[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)

# GeohashKit 

## Usage
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
Geohash.decode("ezs42") // (latitude: 42.60498046875, longitude: -5.60302734375)
```

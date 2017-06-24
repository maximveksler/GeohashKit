Pod::Spec.new do |s|
        s.name         = "JWGeohashKit"
        s.version      = "0.2"
        s.summary      = "Fast, accurate, fully tested geohashing library for Swift"
        s.description  = "```swift"

        s.homepage     = "https://github.com/jwitcig/GeohashKit"

        s.license      = "MIT License"

        s.author       = "Maxim Veksler"

        s.source       = { :git => "https://github.com/jwitcig/GeohashKit.git", :tag => "0.2" }

        s.source_files = "GeohashKit/*.{h,m,swift}"

        s.ios.deployment_target = "8.0"
        # s.osx.deployment_target = "10.9"
        # s.watchos.deployment_target = "2.0"
        # s.tvos.deployment_target = "9.0"
      end

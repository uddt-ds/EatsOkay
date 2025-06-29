// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "EatsOkay",
    platforms: [
        .iOS(.v16)
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.7.1"),
        
        .package(url: "https://github.com/Moya/Moya", from: "15.0.3"),
        .package(url: "https://github.com/ReactiveX/RxSwift", from: "6.9.0"),
        .package(url: "https://github.com/ReactorKit/ReactorKit", from: "3.2.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources", from: "5.0.2"),
        
        .package(url: "https://github.com/onevcat/Kingfisher", from: "8.3.2"),
        .package(url: "https://github.com/googlemaps/ios-maps-sdk.git", from: "10.0.0")
    ]
)

// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "NetworkLayer",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(name: "NetworkLayer", type: .static, targets: ["NetworkLayer"])
    ],
    targets: [
        .target(name: "NetworkLayer", dependencies: []),
        .testTarget(name: "NetworkLayerTests", dependencies: ["NetworkLayer"])
    ]
)


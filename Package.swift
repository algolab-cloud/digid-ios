// swift-tools-version:5.9
// digid iOS SDK 0.1.3: Digid is a binary framework (engine and Swift API compiled);
// DigidModels is the model files as a resource bundle (add it to ship them inside the app).
import PackageDescription

let package = Package(
    name: "Digid",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "Digid", targets: ["Digid"]),
        .library(name: "DigidModels", targets: ["DigidModels"]),
    ],
    targets: [
        .binaryTarget(
            name: "Digid",
            url: "https://github.com/algolab-cloud/digid-ios/releases/download/0.1.3/Digid.xcframework.zip",
            checksum: "e7bfb8841835b0aa138fd2462b0d1cadf31b033ba39f484708c56ea8726e0830"
        ),
        .target(name: "DigidModels", path: "Sources/DigidModels", resources: [.copy("Resources/digid-models")]),
    ]
)

// swift-tools-version:5.9
// digid iOS SDK 0.1.4: Digid is a binary framework (engine and Swift API compiled);
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
            url: "https://github.com/algolab-cloud/digid-ios/releases/download/0.1.4/Digid.xcframework.zip",
            checksum: "b6d7d791150083dc5f771de1f2dd29867ece44dc83f35dd886bf65eb329d9c5a"
        ),
        .target(name: "DigidModels", path: "Sources/DigidModels", resources: [.copy("Resources/digid-models")]),
    ]
)

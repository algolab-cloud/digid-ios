// swift-tools-version:5.9
// digid iOS SDK 0.1.2: Digid is a binary framework (engine and Swift API compiled);
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
            url: "https://github.com/algolab-cloud/digid-ios/releases/download/0.1.2/Digid.xcframework.zip",
            checksum: "52f050b01e65bae66d15591eb5f71f14bfd84b8cfdb8fbd2533d5b1aba2934d1"
        ),
        .target(name: "DigidModels", path: "Sources/DigidModels", resources: [.copy("Resources/digid-models")]),
    ]
)

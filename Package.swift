// swift-tools-version:5.9
// digid iOS SDK 0.1.1: Digid is a binary framework (engine and Swift API compiled);
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
            url: "https://github.com/algolab-cloud/digid-ios/releases/download/0.1.1/Digid.xcframework.zip",
            checksum: "cd98d226d3dc88dd824e2f8ac294e308d68b0559ecfd6cc49d29ac93677df9f7"
        ),
        .target(name: "DigidModels", path: "Sources/DigidModels", resources: [.copy("Resources/digid-models")]),
    ]
)

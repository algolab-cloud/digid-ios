// swift-tools-version:5.9
// digid iOS SDK 0.1.5: Digid is a binary framework (engine and Swift API compiled);
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
            url: "https://github.com/algolab-cloud/digid-ios/releases/download/0.1.5/Digid.xcframework.zip",
            checksum: "29da89a8c62627d0fbe6cdb8b0c52ab53dce9f6ae4e2b9fa9f0ed1ab17e6ea41"
        ),
        .target(name: "DigidModels", path: "Sources/DigidModels", resources: [.copy("Resources/digid-models")]),
    ]
)

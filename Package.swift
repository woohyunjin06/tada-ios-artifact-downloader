// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "ArtifactDownloader",
    platforms: [.macOS(.v11)],
    products: [
        .executable(
            name: "tuist-artifact-downloader",
            targets: ["ArtifactDownloader"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/tuist/ProjectAutomation.git", .exactItem("3.6.0")),
        .package(url: "https://github.com/soto-project/soto.git", from: "6.0.0"),
        .package(url: "https://github.com/soto-project/soto-s3-file-transfer.git", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "ArtifactDownloader",
            dependencies: [
                .product(name: "ProjectAutomation", package: "ProjectAutomation"),
                .product(name: "SotoS3", package: "soto"),
                .product(name: "SotoS3FileTransfer", package: "soto-s3-file-transfer")
            ]
        )
    ]
)

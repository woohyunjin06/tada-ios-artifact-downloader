//
//  main.swift
//  
//
//  Created by HyunJin on 2022/07/04.
//

import ProjectAutomation
import SotoS3
import SotoS3FileTransfer
import Foundation
import AsyncHTTPClient

@main
struct ArtifactDownloader {
    static let bucket = "tada-ios-buildcache"
    
    static func main() async throws {
        let client = AWSClient(
            credentialProvider: .environment,
            httpClientProvider: .createNew
        )
        let s3 = S3(client: client, region: .apnortheast2, timeout: .minutes(10))
        
        async let reCAPTCHA: Void = download(key: "reCAPTCHA", into: "reCAPTCHA/", from: s3)
        async let GoogleMaps: Void = download(key: "GoogleMaps", into: "GoogleMaps/", from: s3)
                  
        _ = await [reCAPTCHA, GoogleMaps]
        print("All downloading completed successfully")
        try? client.syncShutdown()
    }
    
    static func download(key: String, into path: String, from s3: S3) async {
        let s3FileTransfer = S3FileTransferManager(s3: s3, threadPoolProvider: .createNew)
        do {
            print("Downloading \(key) artifact to \(path)")
            try await s3FileTransfer.copy(
                from: S3Folder(url: "s3://\(bucket)/\(key)/")!,
                to: path
            )
            print("Download \(key) completed successfully")
        } catch {
            print("Download \(key) artifact failed: \(error)")
        }
    }
}

extension S3FileTransferManager {
    func copy(
        from s3Folder: S3Folder,
        to folder: String,
        options: GetOptions = .init(),
        progress: @escaping (Double) throws -> Void = { _ in }
    ) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let future: EventLoopFuture<Void> = copy(from: s3Folder, to: folder, options: options, progress: progress)
            future.whenSuccess { _ in
                continuation.resume(returning: Void())
            }
            future.whenFailure { error in
                continuation.resume(throwing: error)
            }
        }
    }
}

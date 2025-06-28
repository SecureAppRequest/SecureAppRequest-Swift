//
//  SecureURLSession.swift
//  SecureAppRequest
//
//  Created by A Avinash Chidambaram on 28/06/25.
//

import Foundation
public final class SecureURLSession: NSObject, URLSessionDelegate, @unchecked Sendable {
    private let cryptoManager: SessionCryptoManager
    private let urlSession: URLSession

    public init(configuration: URLSessionConfiguration = .default, secretKeyData: Data) throws {
        self.cryptoManager = try SessionCryptoManager(secretKeyData: secretKeyData)
        self.urlSession = SecureURLSession.makeSession(configuration: configuration)
        super.init()
    }

    private static func makeSession(configuration: URLSessionConfiguration) -> URLSession {
        let delegateQueue = OperationQueue()
        delegateQueue.maxConcurrentOperationCount = 1
        delegateQueue.name = "com.yourpackage.SecureURLSessionDelegateQueue"
        return URLSession(configuration: configuration, delegate: nil, delegateQueue: delegateQueue)
    }

    public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        var modifiedRequest = request

        if modifiedRequest.wantsEncryptedBundleIdentifier {
            modifiedRequest.allHTTPHeaderFields?.removeValue(forKey: URLRequest.encryptedBundleIdentifierHeaderField)

            guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
                throw SecureURLSessionError.bundleIdentifierNotFound
            }

            let encryptedIdentifier = try cryptoManager.encrypt(string: bundleIdentifier)
            modifiedRequest.addValue(encryptedIdentifier, forHTTPHeaderField: URLRequest.encryptedBundleIdentifierHeaderField)
        }

        return try await urlSession.data(for: modifiedRequest)
    }

    public enum SecureURLSessionError: Error, LocalizedError {
        case bundleIdentifierNotFound
        case encryptionFailed(Error)

        public var errorDescription: String? {
            switch self {
            case .bundleIdentifierNotFound:
                return "Bundle identifier could not be retrieved for encryption."
            case .encryptionFailed(let error):
                return "Encryption of bundle identifier failed: \(error.localizedDescription)"
            }
        }
    }
}

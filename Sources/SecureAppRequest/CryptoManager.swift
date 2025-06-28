//
//  CryptoManager.swift
//  SecureAppRequest
//
//  Created by A Avinash Chidambaram on 28/06/25.
//

// SessionCryptoManager.swift
import Foundation
import CryptoKit

// Made a struct, which is Sendable by default if its members are Sendable (SymmetricKey is Sendable)
internal struct SessionCryptoManager {
    private let secretKey: SymmetricKey // Ensure this is a 'let' constant

    internal init(secretKeyData: Data) throws {
        guard secretKeyData.count == 32 else {
            throw CryptoManagerError.invalidKeyLength
        }
        self.secretKey = SymmetricKey(data: secretKeyData)
    }
    
    internal func encrypt(string: String) throws -> String {
        guard let dataToEncrypt = string.data(using: .utf8) else {
            throw CryptoManagerError.stringConversionFailed
        }
        
        let sealedBox = try AES.GCM.seal(dataToEncrypt, using: self.secretKey)
        let combinedData: Data = sealedBox.combined! // No '!' needed here
        let base64String = combinedData.base64EncodedString()
        
        return base64String
    }
    
    enum CryptoManagerError: Error, LocalizedError {
        case invalidKeyLength
        case stringConversionFailed
        case base64ConversionFailed
        
        var errorDescription: String? {
            switch self {
            case .invalidKeyLength: return "AES-256 key must be 32 bytes (256 bits)."
            case .stringConversionFailed: return "Failed to convert string to Data for encryption."
            case .base64ConversionFailed: return "Failed to convert encrypted data to Base64 string."
            }
        }
    }
}

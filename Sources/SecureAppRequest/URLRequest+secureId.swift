//
//  URLRequest+secureId.swift
//  SecureAppRequest
//
//  Created by A Avinash Chidambaram on 28/06/25.
//

import Foundation


// MARK: - URLRequest+SecureID (Your Package)

// This computed property acts as a "flag" or "hint" for your custom URLSession.
public extension URLRequest {
    static let encryptedBundleIdentifierHeaderField = "X-App-Identifier-Enc"

    // Use `urlRequest.wantsEncryptedBundleIdentifier = true`
    var wantsEncryptedBundleIdentifier: Bool {
        get { (self.allHTTPHeaderFields?[URLRequest.encryptedBundleIdentifierHeaderField] == "placeholder") } // Use a placeholder value to distinguish
        set {
            if newValue {
                // Set a temporary placeholder that your custom URLSession can recognize
                // This doesn't contain the *actual* encrypted ID yet
                self.addValue("placeholder", forHTTPHeaderField: URLRequest.encryptedBundleIdentifierHeaderField)
            } else {
                self.allHTTPHeaderFields?.removeValue(forKey: URLRequest.encryptedBundleIdentifierHeaderField)
            }
        }
    }
}

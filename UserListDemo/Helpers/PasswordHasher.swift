//
//  PasswordHasher.swift
//  UserListDemo
//

import Foundation
import CryptoKit

enum PasswordHasher {
    private static let salt = "UserListDemo_Salt_2025"

    /// Hashes password with SHA256 and salt (one-way; use for storage).
    static func hash(_ password: String) -> String {
        let data = (password + salt).data(using: .utf8)!
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }

    /// Verifies that the given password matches the stored hash.
    static func verify(password: String, hash storedHash: String) -> Bool {
        hash(password) == storedHash
    }
}

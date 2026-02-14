//
//  APIUser.swift
//  UserListDemo
//

import Foundation

struct RandomUserResponse: Codable {
    let id: String?
    let username: String?
    let email: String?
    let name: String?
    let first_name: String?
    let last_name: String?
    let full_name: String?
    let picture: String?
    let avatar: String?
    let phone: String?
    let cell: String?

    var displayName: String {
        let full = full_name ?? name
        if let f = full, !f.isEmpty { return f }
        let firstLast = [first_name, last_name].compactMap { $0 }.joined(separator: " ").trimmingCharacters(in: .whitespaces)
        if !firstLast.isEmpty { return firstLast }
        return username ?? email ?? "Unknown"
    }

    var imageURL: String? { picture ?? avatar }
}

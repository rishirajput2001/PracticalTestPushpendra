//
//  AuthState.swift
//  UserListDemo


import Foundation

enum AuthState {
    static let currentUserIdKey = "currentLoggedInUserId"

    static var currentUserId: String? {
        get { UserDefaults.standard.string(forKey: currentUserIdKey) }
        set { UserDefaults.standard.set(newValue, forKey: currentUserIdKey) }
    }

    static var isLoggedIn: Bool { currentUserId != nil }

    static func logout() {
        currentUserId = nil
    }
}

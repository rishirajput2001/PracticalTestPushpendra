//
//  AuthViewModel.swift
//  UserListDemo
//

import CoreData
import Foundation
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var errorMessage: String?
    @Published var isLoading = false

    private let authService: AuthService
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        self.authService = AuthService(context: context)
        loadCurrentUser()
    }

    func loadCurrentUser() {
        guard let id = AuthState.currentUserId else {
            currentUser = nil
            return
        }
        currentUser = try? authService.user(byId: id)
    }

    func register(fullName: String, email: String, password: String) {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }
        do {
            let user = try authService.register(fullName: fullName, email: email, password: password)
            AuthState.currentUserId = user.id
            currentUser = user
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func login(email: String, password: String) {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }
        do {
            let user = try authService.login(email: email, password: password)
            AuthState.currentUserId = user.id
            currentUser = user
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func logout() {
        AuthState.logout()
        currentUser = nil
    }
}

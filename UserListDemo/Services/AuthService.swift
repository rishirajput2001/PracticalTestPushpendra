//
//  AuthService.swift
//  UserListDemo
//
//  Created by Mac on 14/02/26.

import CoreData
import Foundation

final class AuthService {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func register(fullName: String, email: String, password: String) throws -> User {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", email)
        request.fetchLimit = 1
        let existing = try context.fetch(request)
        if !existing.isEmpty {
            throw AuthError.emailAlreadyUsed
        }
        let user = User(context: context)
        user.id = UUID().uuidString
        user.fullName = fullName
        user.email = email
        user.passwordHash = PasswordHasher.hash(password)
        user.createdAt = Date()
        try context.save()
        return user
    }

    func login(email: String, password: String) throws -> User {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", email)
        request.fetchLimit = 1
        let users = try context.fetch(request)
        guard let user = users.first else { throw AuthError.invalidCredentials }
        guard let hash = user.passwordHash, PasswordHasher.verify(password: password, hash: hash) else {
            throw AuthError.invalidCredentials
        }
        return user
    }

    func user(byId id: String) throws -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
}

enum AuthError: LocalizedError {
    case emailAlreadyUsed
    case invalidCredentials

    var errorDescription: String? {
        switch self {
        case .emailAlreadyUsed: return "This email is already registered."
        case .invalidCredentials: return "Invalid email or password."
        }
    }
}

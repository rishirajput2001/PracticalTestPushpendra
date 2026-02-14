//
//  UserFriendService.swift
//  UserListDemo
//
//  Created by Mac on 14/02/26.

import CoreData
import Foundation

final class UserFriendService {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func addFavorite(ownerUserId: String, apiUser: RandomUserResponse) throws {
        guard let owner = try fetchUser(id: ownerUserId) else { return }
        let apiId = apiUser.id ?? apiUser.email ?? UUID().uuidString
        let existingRequest: NSFetchRequest<UserFriend> = UserFriend.fetchRequest()
        existingRequest.predicate = NSPredicate(format: "user.id == %@ AND apiUserId == %@", ownerUserId, apiId)
        existingRequest.fetchLimit = 1
        if (try? context.fetch(existingRequest).first) != nil { return }
        let friend = UserFriend(context: context)
        friend.id = UUID().uuidString
        friend.user = owner
        friend.apiUserId = apiId
        friend.name = apiUser.displayName
        friend.email = apiUser.email
        friend.pictureURL = apiUser.imageURL
        friend.addedAt = Date()
        try context.save()
    }

    func removeFavorite(ownerUserId: String, friendId: String) throws {
        let request: NSFetchRequest<UserFriend> = UserFriend.fetchRequest()
        request.predicate = NSPredicate(format: "user.id == %@ AND id == %@", ownerUserId, friendId)
        request.fetchLimit = 1
        guard let friend = try context.fetch(request).first else { return }
        context.delete(friend)
        try context.save()
    }

    func favorites(ownerUserId: String) throws -> [UserFriend] {
        let request: NSFetchRequest<UserFriend> = UserFriend.fetchRequest()
        request.predicate = NSPredicate(format: "user.id == %@", ownerUserId)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \UserFriend.addedAt, ascending: false)]
        return try context.fetch(request)
    }

    func isFavorite(ownerUserId: String, apiUserId: String) throws -> Bool {
        let request: NSFetchRequest<UserFriend> = UserFriend.fetchRequest()
        request.predicate = NSPredicate(format: "user.id == %@ AND apiUserId == %@", ownerUserId, apiUserId)
        request.fetchLimit = 1
        return (try context.fetch(request).first) != nil
    }

    private func fetchUser(id: String) throws -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
}

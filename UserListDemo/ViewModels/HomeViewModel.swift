//
//  HomeViewModel.swift
//  UserListDemo
//

import CoreData
import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var apiUsers: [RandomUserResponse] = []
    @Published var favorites: [UserFriend] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let apiService = RandomUserAPIService()
    private let userFriendService: UserFriendService
    private let ownerUserId: String

    init(context: NSManagedObjectContext, ownerUserId: String) {
        self.userFriendService = UserFriendService(context: context)
        self.ownerUserId = ownerUserId
    }

    func loadRandomUsers() {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                let newUsers = try await apiService.fetchRandomUsers(count: 10)
                apiUsers = newUsers
            } catch {
                errorMessage = error.localizedDescription
                apiUsers = []
            }
            isLoading = false
        }
    }

    func loadFavorites() {
        do {
            favorites = try userFriendService.favorites(ownerUserId: ownerUserId)
        } catch {
            errorMessage = error.localizedDescription
            favorites = []
        }
    }

    func addFavorite(_ apiUser: RandomUserResponse) {
        do {
            try userFriendService.addFavorite(ownerUserId: ownerUserId, apiUser: apiUser)
            loadFavorites()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func removeFavorite(friendId: String) {
        do {
            try userFriendService.removeFavorite(ownerUserId: ownerUserId, friendId: friendId)
            loadFavorites()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func isFavorite(apiUserId: String) -> Bool {
        favorites.contains { $0.apiUserId == apiUserId }
    }
}

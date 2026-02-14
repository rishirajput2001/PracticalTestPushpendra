//
//  FavoriteUsersView.swift
//  UserListDemo
//
//  Created by Mac on 14/02/26.


import SwiftUI
import CoreData
import SDWebImageSwiftUI

struct FavoriteUsersView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ZStack {
            // Background GIF
            AnimatedImage(name: "bg_parpal_gif.gif")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)

            Group {
                if viewModel.favorites.isEmpty {
                    ContentUnavailableView(
                        "No favorites",
                        systemImage: "star.slash",
                        description: Text("Add users from the User list tab.")
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.favorites, id: \.objectID) { friend in
                                FavoriteCardView(
                                    name: friend.name ?? "",
                                    email: friend.email ?? "",
                                    imageURL: friend.pictureURL,
                                    onRemove: { viewModel.removeFavorite(friendId: friend.id ?? "") }
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .onAppear { viewModel.loadFavorites() }
    }
}

struct FavoriteCardView: View {
    let name: String
    let email: String
    let imageURL: String?
    let onRemove: () -> Void

    private let cardCornerRadius: CGFloat = 16
    private let darkPurpleTop = Color(red: 0.29, green: 0.04, blue: 0.40)      // #4A0A66
    private let darkPurpleBottom = Color(red: 0.24, green: 0.03, blue: 0.30)   // #3D084D
    private let borderPurple = Color(red: 0.60, green: 0.35, blue: 0.78)       // #9A58C8

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: imageURL.flatMap { URL(string: $0) }) { phase in
                switch phase {
                case .success(let image): image.resizable().scaledToFill()
                default: Image(systemName: "person.circle.fill").resizable().foregroundStyle(.white.opacity(0.7))
                }
            }
            .frame(width: 56, height: 56)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(name).font(.headline).foregroundStyle(.white)
                Text(email).font(.caption).foregroundStyle(.white.opacity(0.85))
            }

            Spacer()

            Button {
                onRemove()
            } label: {
                Text("Remove")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color(red: 1, green: 0.4, blue: 0.4))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .fill(
                    LinearGradient(
                        colors: [darkPurpleTop, darkPurpleBottom],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .strokeBorder(borderPurple.opacity(0.9), lineWidth: 1.5)
        )
        .shadow(color: borderPurple.opacity(0.5), radius: 8, x: 0, y: 0)
    }
}

//
//  UserListView.swift
//  UserListDemo
//
//  Created by Mac on 14/02/26.

import SwiftUI
import SDWebImageSwiftUI

struct UserListView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ZStack {
            // Background GIF
            AnimatedImage(name: "bg_parpal_gif.gif")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)

            Group {
                if viewModel.isLoading && viewModel.apiUsers.isEmpty {
                    ProgressView("Loading users…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        if let error = viewModel.errorMessage {
                            Section {
                                Text(error).foregroundStyle(.red)
                            }
                        }
                        ForEach(Array(viewModel.apiUsers.enumerated()), id: \.offset) { _, user in
                            let apiId = user.id ?? user.email ?? ""
                            UserRowView(
                                name: user.displayName,
                                email: user.email ?? "",
                                imageURL: user.imageURL,
                                isFavorite: viewModel.isFavorite(apiUserId: apiId),
                                onFavorite: { viewModel.addFavorite(user) }
                            )
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .refreshable { viewModel.loadRandomUsers() }
                }
            }
        }
        .onAppear { viewModel.loadRandomUsers() }
    }
}

struct UserRowView: View {
    let name: String
    let email: String
    let imageURL: String?
    let isFavorite: Bool
    let onFavorite: () -> Void

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
            .frame(width: 50, height: 50)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(name).font(.headline).foregroundStyle(.white)
                Text(email).font(.caption).foregroundStyle(.white.opacity(0.85))
            }

            Spacer()

            Button {
                onFavorite()
            } label: {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundStyle(isFavorite ? .yellow : .white.opacity(0.7))
            }
            .buttonStyle(.plain)
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
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
    }
}

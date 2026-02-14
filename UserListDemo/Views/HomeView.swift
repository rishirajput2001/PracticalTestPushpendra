//
//  HomeView.swift
//  UserListDemo
//
//  Created by Mac on 14/02/26.

import SwiftUI
import CoreData

struct HomeView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @StateObject private var homeViewModel: HomeViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showLogoutAlert = false

    init(authViewModel: AuthViewModel, context: NSManagedObjectContext, ownerUserId: String) {
        self.authViewModel = authViewModel
        _homeViewModel = StateObject(wrappedValue: HomeViewModel(context: context, ownerUserId: ownerUserId))
    }

    var body: some View {
        TabView {
            UserListView(viewModel: homeViewModel)
                .tabItem {
                    Label("User List", systemImage: "person.2")
                }

            FavoriteUsersView(viewModel: homeViewModel)
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Logout") {
                    showLogoutAlert = true
                }
            }
        }
        .alert("Logout", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("OK") {
                authViewModel.logout()
            }
        } message: {
            Text("Are you sure you want to logout?")
        }
    }
}

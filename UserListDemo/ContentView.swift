//
//  ContentView.swift
//  UserListDemo
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var authViewModel: AuthViewModel

    init(context: NSManagedObjectContext) {
        _authViewModel = StateObject(wrappedValue: AuthViewModel(context: context))
    }

    var body: some View {
        Group {
            if let user = authViewModel.currentUser, let userId = user.id {
                NavigationStack {
                    HomeView(
                        authViewModel: authViewModel,
                        context: viewContext,
                        ownerUserId: userId
                    )
                }
            } else {
                LoginView(viewModel: authViewModel)
            }
        }
        .onAppear { authViewModel.loadCurrentUser() }
    }
}

#Preview {
    ContentView(context: PersistenceController.preview.container.viewContext)
}

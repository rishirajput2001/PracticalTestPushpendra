# UserListDemo

A SwiftUI iOS app that lets you sign up, log in, browse a list of random users, and save favorites. Built with SwiftUI, Core Data, and the API Ninjas Random User API.

## Features

- **Authentication** — Sign up and log in with email and password (stored locally with Core Data)
- **User list** — Browse random users fetched from the [API Ninjas Random User API](https://api-ninjas.com/api/randomuser)
- **Favorites** — Save users to a favorites list (persisted with Core Data)
- **Modern UI** — SwiftUI views with custom styling and animations

## Requirements

- Xcode 15+ (or latest stable)
- iOS 17+
- Swift 5.9+

## Getting started

1. **Clone or open the project**
   ```bash
   cd UserListDemo
   open UserListDemo.xcodeproj
   ```

2. **Configure the API key**  
   The app uses [API Ninjas](https://api-ninjas.com/) for random user data. Set your API key in:
   - `UserListDemo/Config/APIConfig.swift`  
   Replace the `apiKey` value with your own key from [api-ninjas.com](https://api-ninjas.com/).

3. **Build and run**  
   Select a simulator or device and run with **⌘R**.

## Project structure

```
UserListDemo/
├── UserListDemoApp.swift      # App entry point
├── ContentView.swift           # Root view (auth vs home)
├── Config/
│   └── APIConfig.swift        # API base URL and key
├── Models/
│   └── APIUser.swift          # Random user model
├── Views/
│   ├── LoginView.swift
│   ├── SignUpView.swift
│   ├── HomeView.swift         # Tab container (User list + Favorites)
│   ├── UserListView.swift
│   └── FavoriteUsersView.swift
├── ViewModels/
│   ├── AuthViewModel.swift
│   └── HomeViewModel.swift
├── Services/
│   ├── AuthService.swift
│   ├── RandomUserAPIService.swift
│   └── UserFriendService.swift  # Favorites / Core Data
├── Helpers/
│   ├── AuthState.swift
│   ├── AnimatedSheen.swift
│   ├── ShakeModifier.swift
│   ├── PasswordHasher.swift
│   └── Color.swift
├── Persistence.swift          # Core Data stack
└── Assets.xcassets/          # Images and colors
```

## Dependencies

- **SDWebImageSwiftUI** — Async image loading for user avatars (via Swift Package Manager)

## License

This project is for demonstration purposes.

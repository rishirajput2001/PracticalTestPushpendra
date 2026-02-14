//
//  LoginView.swift
//  UserListDemo
//
//  Created by Mac on 14/02/26.


import SwiftUI
import SDWebImageSwiftUI

private enum LoginField: Hashable {
    case email, password
}

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var showSignUp = false
    @FocusState private var focusedField: LoginField?

    @State private var emailError: String?
    @State private var passwordError: String?
    @State private var emailShakeTrigger = 0
    @State private var passwordShakeTrigger = 0
    /// Stable width so layout doesn't shift when keyboard opens (GeometryReader shrinks).
    @State private var contentWidth: CGFloat = 0
    
    private var isEmailValid: Bool {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty && trimmed.contains("@") && trimmed.contains(".")
    }
    
    private var isPasswordValid: Bool {
        !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func validateAndLogin() {
        viewModel.errorMessage = nil
        emailError = nil
        passwordError = nil
        
        var hasError = false
        if !isEmailValid {
            emailError = "Please enter a valid email address."
            emailShakeTrigger += 1
            hasError = true
        }
        if !isPasswordValid {
            passwordError = "Please enter your password."
            passwordShakeTrigger += 1
            hasError = true
        }
        guard !hasError else { return }
        
        viewModel.login(email: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password)
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let width = contentWidth > 0 ? contentWidth : geometry.size.width
                ZStack {
                    // 🔹 Background GIF
                    AnimatedImage(name: "bg_parpal_gif.gif")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea(.all)
                    
                    ScrollView {
                        ScrollViewReader { proxy in
                            VStack(spacing: 20) {
                                Text("Welcome Back")
                                    .font(.title.bold())
                                    .foregroundColor(Color(hex: "#FFF056"))
                                    .padding(.top,80)

                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 12) {
                                        Image("mage_email")
                                        .frame(width: 18, height: 18)
                                        .padding(.leading, 18)

                                    ZStack(alignment: .leading) {
                                        // Placeholder
                                        if email.isEmpty {
                                            Text("Email")
                                                .foregroundColor(.white.opacity(0.8))
                                                .padding(.leading, -4)
                                            
                                        }
                                        
                                        TextField("", text: $email)
                                            .textContentType(.emailAddress)
                                            .textInputAutocapitalization(.never)
                                            .keyboardType(.emailAddress)
                                            .focused($focusedField, equals: .email)
                                            .foregroundColor(.white)
                                            .onChange(of: email) { _, _ in
                                                if emailError != nil { emailError = nil }
                                            }
                                            .padding(.leading, -4)
                                    }
                                    .frame(height: 52)
                                }
                                .frame(height: 52)
                                .background(Color(hex: "#17074D"))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(emailError != nil ? Color.red : Color(hex:"#A15EFA"), lineWidth: emailError != nil ? 2 : 2)
                                )
                                .cornerRadius(24)
                                .shake(trigger: emailShakeTrigger)

                                if let error = emailError {
                                    Text(error)
                                        .font(.caption)
                                        .foregroundStyle(.red)
                                }
                            }
                            .id(LoginField.email)

                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 12) {
                                    Image("lock_icon_y")
                                        .frame(width: 18, height: 18)
                                        .padding(.leading, 18)

                                    ZStack(alignment: .leading) {
                                        // Placeholder
                                        if password.isEmpty {
                                            Text("Password")
                                                .foregroundColor(.white.opacity(0.8))
                                                .padding(.leading, -4)
                                        }
                                        
                                        Group {
                                            if isPasswordVisible {
                                                TextField("", text: $password)
                                                    .textContentType(.password)
                                                    .autocorrectionDisabled()
                                            } else {
                                                SecureField("", text: $password)
                                                    .textContentType(.password)
                                            }
                                        }
                                        .focused($focusedField, equals: .password)
                                        .foregroundColor(.white)
                                        .onChange(of: password) { _, _ in
                                            if passwordError != nil { passwordError = nil }
                                        }
                                        .padding(.leading, -4)
                                    }
                                    .frame(height: 52)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                    Button {
                                        isPasswordVisible.toggle()
                                    } label: {
                                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                            .foregroundColor(.white.opacity(0.9))
                                            .frame(width: 44, height: 44)
                                    }
                                    .padding(.trailing, 8)
                                }
                                .frame(height: 52)
                                .background(Color(hex: "#17074D"))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(passwordError != nil ? Color.red : Color(hex:"#A15EFA"), lineWidth: passwordError != nil ? 2 : 2)
                                )
                                .cornerRadius(24)
                                .shake(trigger: passwordShakeTrigger)
                                
                                if let error = passwordError {
                                    Text(error)
                                        .font(.caption)
                                        .foregroundStyle(.red)
                                }
                            }
                            .id(LoginField.password)

                            if let error = viewModel.errorMessage {
                                Text(error)
                                    .font(.caption)
                                    .foregroundStyle(.red)
                            }

                            // Login Button (Glassy, premium)
                            Button(action: {
                                validateAndLogin()
                            }) {
                                ZStack {
                                    // Glass material base
                                    BlurView(style: .systemUltraThinMaterialDark)
                                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                                        .overlay(
                                            // Palette tint that harmonizes with background
                                            Color(hex: "#A15EFA")
                                                .opacity(100) // adjust 0.18–0.28 for stronger tint
                                                .blendMode(.overlay)
                                                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                                        )
                                        .overlay(
                                            // Inner soft highlight
                                            LinearGradient(
                                                colors: [
                                                    Color.white.opacity(0.28),
                                                    Color.white.opacity(0.06)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                            .blendMode(.screen)
                                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                                        )
                                        .overlay(
                                            // Gradient border for premium edge
                                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                                .stroke(
                                                    LinearGradient(
                                                        colors: [
                                                            Color.white.opacity(0.75),
                                                            Color.white.opacity(0.18)
                                                        ],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    lineWidth: 1.2
                                                )
                                        )
                                    // Dual shadow: colored glow + depth
                                        .shadow(color: Color(hex: "#A15EFA").opacity(0.35), radius: 24, x: 0, y: 10)
                                        .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 6)
                                    
                                    // Title
                                    Text("Log In")
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.35), radius: 6, x: 0, y: 2)
                                    
                                    // Animated sheen sweep
                                    AnimatedSheen()
                                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                        .allowsHitTesting(false)
                                }
                                //.frame(maxWidth: .infinity)
                                .frame(height: 52)
                            }
                            .disabled(viewModel.isLoading)
                            .padding(.top, 24)
                            .buttonStyle(GlassPressStyle())
                                                        
                            HStack {
                                Spacer()
                                Text("Don't have an account?")
                                    .foregroundColor(Color(hex: "#FFFFFF"))
                                    .font(.subheadline)
                                
                                Button(action: {
                                    showSignUp = true
                                }) {
                                    Text("Sign Up")
                                        .underline()
                                        .foregroundColor(Color(hex: "#FFF056"))
                                        .font(.subheadline)
                                }
                                Spacer()
                            }
                            .padding(.top, 20)
                            }
                            .onChange(of: focusedField) { _, newValue in
                                guard let field = newValue else { return }
                                withAnimation(.easeOut(duration: 0.25)) {
                                    proxy.scrollTo(field, anchor: .center)
                                }
                            }
                        }
                        .frame(width: width - 24)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .scrollIndicators(.hidden)
                    .scrollDismissesKeyboard(.interactively)
                    .sheet(isPresented: $showSignUp) {
                        SignUpView(viewModel: viewModel)
                            .onDisappear {
                                if viewModel.currentUser != nil { showSignUp = false }
                            }
                    }
                    //.padding(.horizontal, 24)
                }
                .frame(width: width, height: geometry.size.height)
                .onAppear { contentWidth = geometry.size.width }
                .onChange(of: geometry.size.width) { _, new in
                    if new > contentWidth { contentWidth = new }
                }
            }
        }
    }
}

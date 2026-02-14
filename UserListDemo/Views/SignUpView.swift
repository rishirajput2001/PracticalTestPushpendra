//
//  SignUpView.swift
//  UserListDemo
//
//  Created by Mac on 14/02/26.

import SwiftUI
import SDWebImageSwiftUI

private enum SignUpField: Hashable {
    case fullName, email, password, confirmPassword
}

struct SignUpView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: SignUpField?

    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false

    @State private var fullNameError: String?
    @State private var emailError: String?
    @State private var passwordError: String?
    @State private var confirmPasswordError: String?
    @State private var fullNameShakeTrigger = 0
    @State private var emailShakeTrigger = 0
    @State private var passwordShakeTrigger = 0
    @State private var confirmPasswordShakeTrigger = 0
    /// Stable width so layout doesn't shift when keyboard opens (GeometryReader shrinks).
    @State private var contentWidth: CGFloat = 0

    private var isFullNameValid: Bool {
        fullNameErrorMessage() == nil
    }

    /// Full name: 2–50 characters, letters and spaces only (no numbers or special characters).
    private func fullNameErrorMessage() -> String? {
        let trimmed = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return "Please enter your full name." }
        if trimmed.count < 2 { return "Full name must be at least 2 characters." }
        if trimmed.count > 50 { return "Full name must be at most 50 characters." }
        let hasOnlyLettersAndSpaces = trimmed.allSatisfy { $0.isLetter || $0.isWhitespace }
        if !hasOnlyLettersAndSpaces { return "Full name cannot contain numbers or special characters." }
        return nil
    }

    private var isEmailValid: Bool {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty && trimmed.contains("@") && trimmed.contains(".")
    }

    private var isPasswordValid: Bool {
        let trimmed = password.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 8 else { return false }
        let hasNumber = trimmed.contains(where: { $0.isNumber })
        let specialCharacters = CharacterSet.punctuationCharacters.union(CharacterSet.symbols)
        let hasSpecialCharacter = trimmed.unicodeScalars.contains(where: { specialCharacters.contains($0) })
        return hasNumber && hasSpecialCharacter
    }

    private var passwordRequirementMessage: String {
        "Password must be at least 8 characters and contain one number and one special character."
    }

    private func validateAndSignUp() {
        viewModel.errorMessage = nil
        fullNameError = nil
        emailError = nil
        passwordError = nil
        confirmPasswordError = nil

        var hasError = false
        if let message = fullNameErrorMessage() {
            fullNameError = message
            fullNameShakeTrigger += 1
            hasError = true
        }
        if !isEmailValid {
            emailError = "Please enter a valid email address."
            emailShakeTrigger += 1
            hasError = true
        }
        if !isPasswordValid {
            let trimmed = password.trimmingCharacters(in: .whitespacesAndNewlines)
            passwordError = trimmed.isEmpty
                ? "Please enter a password."
                : passwordRequirementMessage
            passwordShakeTrigger += 1
            hasError = true
        }
        if isPasswordValid && confirmPassword != password {
            confirmPasswordError = "Passwords do not match."
            confirmPasswordShakeTrigger += 1
            hasError = true
        }
        guard !hasError else { return }

        viewModel.register(
            fullName: fullName.trimmingCharacters(in: .whitespacesAndNewlines),
            email: email.trimmingCharacters(in: .whitespacesAndNewlines),
            password: password
        )
    }

    var body: some View {
        GeometryReader { geometry in
            let width = contentWidth > 0 ? contentWidth : geometry.size.width
            ZStack {
                // Background GIF (same as Login)
                AnimatedImage(name: "bg_parpal_gif.gif")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)

                ScrollView {
                    ScrollViewReader { proxy in
                        VStack(spacing: 20) {
                            Text("Create Account")
                                .font(.title.bold())
                                .foregroundColor(Color(hex: "#FFF056"))
                                .padding(.top,100)

                            // Full name – styled like Login email/password
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 12) {
                                    Image(systemName: "person")
                                    .foregroundColor(.white.opacity(0.9))
                                    .frame(width: 18, height: 18)
                                    .padding(.leading, 18)

                                ZStack(alignment: .leading) {
                                    if fullName.isEmpty {
                                        Text("Full name")
                                            .foregroundColor(.white.opacity(0.8))
                                            .padding(.leading, -4)
                                    }
                                    TextField("", text: $fullName)
                                        .textContentType(.name)
                                        .textInputAutocapitalization(.words)
                                        .focused($focusedField, equals: .fullName)
                                        .foregroundColor(.white)
                                        .onChange(of: fullName) { _, _ in
                                            if fullNameError != nil { fullNameError = nil }
                                        }
                                        .padding(.leading, -4)
                                }
                                .frame(height: 52)
                            }
                            .frame(height: 52)
                            .background(Color(hex: "#17074D"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(fullNameError != nil ? Color.red : Color(hex: "#A15EFA"), lineWidth: fullNameError != nil ? 2 : 2)
                            )
                            .cornerRadius(24)
                            .shake(trigger: fullNameShakeTrigger)

                            if let error = fullNameError {
                                Text(error)
                                    .font(.caption)
                                    .foregroundStyle(.red)
                            }
                        }
                        .id(SignUpField.fullName)

                        // Email – same style as Login
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 12) {
                                Image("mage_email")
                                    .frame(width: 18, height: 18)
                                    .padding(.leading, 18)

                                ZStack(alignment: .leading) {
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
                                    .stroke(emailError != nil ? Color.red : Color(hex: "#A15EFA"), lineWidth: emailError != nil ? 2 : 2)
                            )
                            .cornerRadius(24)
                            .shake(trigger: emailShakeTrigger)

                            if let error = emailError {
                                Text(error)
                                    .font(.caption)
                                    .foregroundStyle(.red)
                            }
                        }
                        .id(SignUpField.email)

                        // Password – same style as Login
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 12) {
                                Image("lock_icon_y")
                                    .frame(width: 18, height: 18)
                                    .padding(.leading, 18)

                                ZStack(alignment: .leading) {
                                    if password.isEmpty {
                                        Text("Password")
                                            .foregroundColor(.white.opacity(0.8))
                                            .padding(.leading, -4)
                                    }
                                    Group {
                                        if isPasswordVisible {
                                            TextField("", text: $password)
                                                .textContentType(.newPassword)
                                                .autocorrectionDisabled()
                                        } else {
                                            SecureField("", text: $password)
                                                .textContentType(.newPassword)
                                        }
                                    }
                                    .focused($focusedField, equals: .password)
                                    .foregroundColor(.white)
                                    .onChange(of: password) { _, _ in
                                        if passwordError != nil { passwordError = nil }
                                        if confirmPasswordError != nil && password == confirmPassword { confirmPasswordError = nil }
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
                                    .stroke(passwordError != nil ? Color.red : Color(hex: "#A15EFA"), lineWidth: passwordError != nil ? 2 : 2)
                            )
                            .cornerRadius(24)
                            .shake(trigger: passwordShakeTrigger)

                            if let error = passwordError {
                                Text(error)
                                    .font(.caption)
                                    .foregroundStyle(.red)
                            }
                        }
                        .id(SignUpField.password)

                        // Confirm password – same style as Login
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 12) {
                                Image("lock_icon_y")
                                    .frame(width: 18, height: 18)
                                    .padding(.leading, 18)

                                ZStack(alignment: .leading) {
                                    if confirmPassword.isEmpty {
                                        Text("Confirm password")
                                            .foregroundColor(.white.opacity(0.8))
                                            .padding(.leading, -4)
                                    }
                                    Group {
                                        if isConfirmPasswordVisible {
                                            TextField("", text: $confirmPassword)
                                                .textContentType(.newPassword)
                                                .autocorrectionDisabled()
                                        } else {
                                            SecureField("", text: $confirmPassword)
                                                .textContentType(.newPassword)
                                        }
                                    }
                                    .focused($focusedField, equals: .confirmPassword)
                                    .foregroundColor(.white)
                                    .onChange(of: confirmPassword) { _, _ in
                                        if confirmPasswordError != nil { confirmPasswordError = nil }
                                    }
                                    .padding(.leading, -4)
                                }
                                .frame(height: 52)
                                .frame(maxWidth: .infinity, alignment: .leading)

                                Button {
                                    isConfirmPasswordVisible.toggle()
                                } label: {
                                    Image(systemName: isConfirmPasswordVisible ? "eye.slash" : "eye")
                                        .foregroundColor(.white.opacity(0.9))
                                        .frame(width: 44, height: 44)
                                }
                                .padding(.trailing, 8)
                            }
                            .frame(height: 52)
                            .background(Color(hex: "#17074D"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(confirmPasswordError != nil ? Color.red : Color(hex: "#A15EFA"), lineWidth: confirmPasswordError != nil ? 2 : 2)
                            )
                            .cornerRadius(24)
                            .shake(trigger: confirmPasswordShakeTrigger)

                            if let error = confirmPasswordError {
                                Text(error)
                                    .font(.caption)
                                    .foregroundStyle(.red)
                            }
                        }
                        .id(SignUpField.confirmPassword)

                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }

                        // Sign Up Button (Glassy, premium)
                        Button(action: {
                            validateAndSignUp()
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
                                Text("Sign Up")
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

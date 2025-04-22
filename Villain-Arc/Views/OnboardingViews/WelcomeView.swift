//
//  OnboardingView.swift
//  WelcomeView.swift 4/12/25.
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/10/25.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("showWelcomeView") var showWelcomeView: Bool = true
    @State private var opacity: Double = 0
    @State private var failedSignInAlert = false
    
    @State private var scrollPosition: ScrollPosition = .init()
    @State private var currentScrollOffset: CGFloat = 0
    @State private var timer = Timer.publish(every: 0.01, on: .current, in: .default).autoconnect()
    
    private func handleAuthResult(_ result: AuthenticationResult) {
        switch result {
        case .error:
            failedSignInAlert = true
        case .newUser:
            showWelcomeView = false
            timer.upstream.connect().cancel()
        case .existingUser:
            DataManager.shared.downloadUserData(context: modelContext)
            timer.upstream.connect().cancel()
        }
    }
    
    private func signInWithGoogle() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        Task {
            do {
                try await AuthManager.shared.signInGoogle { result in
                    handleAuthResult(result)
                }
            } catch {
                handleAuthResult(.error)
            }
        }
    }
    
    private func signInWithApple() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        Task {
            await AuthManager.shared.signInApple { result in
                handleAuthResult(result)
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Villain Arc")
                .font(.system(size: 70, weight: .bold, design: .rounded))
                .opacity(opacity)
            
            if showWelcomeView {
                VStack {
                    Spacer()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(Card.cards) {
                                CarouselCardView($0)
                            }
                        }
                    }
                    .scrollPosition($scrollPosition)
                    .containerRelativeFrame(.vertical) { value, _ in
                        value * 0.50
                    }
                    .scrollClipDisabled()
                    .scrollDisabled(true)
                    
                    Spacer()
                    
                    VStack(spacing: 15) {
                        GoogleSignInButton()
                        AppleSignInButton()
                    }
                }
                .opacity(opacity)
                .alert("Failed to Sign In", isPresented: $failedSignInAlert) {
                    Button("Ok", role: .cancel) { }
                } message: {
                    Text("Failed to sign in. Please try again later.")
                }
                .onReceive(timer) { _ in
                    currentScrollOffset += 0.35
                    scrollPosition.scrollTo(x: currentScrollOffset)
                }
                
            } else {
                UserQuestionsView()
                    .transition(.blurReplace)
                    .opacity(opacity)
            }
        }
        .safeAreaPadding(.vertical)
        .animation(.smooth, value: showWelcomeView)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.linear(duration: 1)) {
                    self.opacity = 1
                }
            }
        }
    }
    
    @ViewBuilder
    private func GoogleSignInButton() -> some View {
        Button {
            signInWithGoogle()
        } label: {
            HStack {
                Image("google.logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 19)
                Text("Continue with Google")
            }
            .signInButtonStyle()
        }
    }
    
    @ViewBuilder
    private func AppleSignInButton() -> some View {
        Button {
            signInWithApple()
        } label: {
            Label("Continue with Apple", systemImage: "apple.logo")
                .signInButtonStyle()
        }
    }
    
    @ViewBuilder
    private func CarouselCardView(_ card: Card) -> some View {
        GeometryReader {
            let size = $0.size
            
            Image(card.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipShape(.rect(cornerRadius: 20))
        }
        .frame(width: 220)
        .scrollTransition(.interactive.threshold(.centered), axis: .horizontal) { content, phase in
            content
                .offset(y: phase == .identity ? -10 : 0)
                .rotationEffect(.degrees(phase.value * 5), anchor: .bottom)
        }
    }
}

#Preview {
    WelcomeView()
}

struct Card: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var image: String
    
    static let cards: [Card] = [
        .init(image: "background1"),
        .init(image: "background2"),
        .init(image: "background3"),
        .init(image: "background4"),
        .init(image: "background1"),
        .init(image: "background2"),
        .init(image: "background3"),
        .init(image: "background4"),
        .init(image: "background1"),
        .init(image: "background2"),
        .init(image: "background3"),
        .init(image: "background4"),
        .init(image: "background1"),
        .init(image: "background2"),
        .init(image: "background3"),
        .init(image: "background4"),
    ]
}

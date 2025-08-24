import SwiftUI

struct AboutUsView: View {
    @State private var animatedText = ""
    private let fullText = "No life should ever be lost to a shortage of blood. Through innovation, transparency, and compassion, we make blood donation safer, more accessible, and more efficient — because every drop counts."
    
    @State private var showCard = false
    @State private var gradientShift = false
    
    var body: some View {
        ZStack {
            // 🔴 Animated Gradient Background
            LinearGradient(colors: [.red, .pink, .purple],
                           startPoint: gradientShift ? .topLeading : .bottomTrailing,
                           endPoint: gradientShift ? .bottomTrailing : .topLeading)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: gradientShift)
            
            VStack(spacing: 30) {
                
                // 🩸 Title
                Text("Our Mission")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                    .padding(.top, 50)
                
                // ✨ Typing Animation Text
                Text(animatedText)
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.black.opacity(0.25))
                            .shadow(radius: 10)
                    )
                    .padding(.horizontal)
                
                // 🪄 Animated Fade-in Card
                if showCard {
                    VStack(spacing: 15) {
                        Image(systemName: "drop.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                        
                        Text("Every Drop Counts ❤️")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.black.opacity(0.25))
                            .shadow(radius: 10)
                    )
                    .transition(.scale.combined(with: .opacity))
                }
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            gradientShift.toggle()
            typeText()
            withAnimation(.easeInOut(duration: 1.5).delay(5)) {
                showCard = true
            }
        }
    }
    
    // Typing Effect Logic
    private func typeText() {
        animatedText = ""
        var charIndex = 0.0
        for letter in fullText {
            DispatchQueue.main.asyncAfter(deadline: .now() + charIndex * 0.05) {
                animatedText.append(letter)
            }
            charIndex += 1
        }
    }
}

#Preview {
    AboutUsView()
}

import SwiftUI

struct AboutUsView: View {
    @State private var animateGlow = false
    @State private var fadeInText = false
    
    var body: some View {
        ZStack {
            // Background gradient animation
            LinearGradient(
                gradient: Gradient(colors: [.red.opacity(0.6), .pink.opacity(0.4), .white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .opacity(0.9)
            
            VStack(spacing: 30) {
                // Animated Heart Icon
                Image(systemName: "heart.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.pink)
                    .shadow(color: .red.opacity(0.7), radius: animateGlow ? 20 : 5)
                    .scaleEffect(animateGlow ? 1.6 : 1.0)
                    .animation(
                        .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                        value: animateGlow
                    )
                
                // Title
                Text("Our Mission")
                    .font(.largeTitle.bold())
                    .foregroundColor(.primary)
                    .opacity(fadeInText ? 1 : 0)
                    .offset(y: fadeInText ? 0 : 20)
                    .animation(.easeOut(duration: 1).delay(0.5), value: fadeInText)
                
                // Mission Statement
                Text("""
                No life should ever be lost to a shortage of blood.  
                Through innovation, transparency, and compassion,  
                we make blood donation safer, more accessible,  
                and more efficient — because every drop counts.
                """)
                    .multilineTextAlignment(.center)
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 20)
                    .opacity(fadeInText ? 1 : 0)
                    .offset(y: fadeInText ? 0 : 20)
                    .animation(.easeOut(duration: 1).delay(1), value: fadeInText)
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            animateGlow = true
            fadeInText = true
        }
    }
}

#Preview {
    AboutUsView()
}

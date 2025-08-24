import SwiftUI

struct AboutUsView: View {
    // ✍️ Typing Animation
    @State private var animatedText = ""
    private let fullText = "At LifeLine, we connect donors with those in need using technology and compassion."
    
    // ❤️ Heart + Confetti
    @State private var showHeart = false
    @State private var showConfetti = false
    @State private var showDetails = false
    
    // 🌈 Gradient Shift
    @State private var gradientShift = false
    
    // 📈 Heartbeat Line
    @State private var animateLine = false
    
    var body: some View {
        ZStack {
            // 🌈 Animated Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [.red, .purple, .blue, .pink]),
                startPoint: gradientShift ? .topLeading : .bottomTrailing,
                endPoint: gradientShift ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 5).repeatForever(autoreverses: true), value: gradientShift)
            .onAppear {
                gradientShift.toggle()
                typeWriter()
                startHeartbeat()
            }
            
            VStack(spacing: 30) {
                // ✍️ Typing Mission Statement
                Text(animatedText)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                // 📈 Heartbeat Line
                HeartbeatShape()
                    .trim(from: 0, to: animateLine ? 1 : 0)
                    .stroke(.white, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                    .frame(height: 150)
                    .padding(.horizontal, 30)
                
                // ❤️ Pulsating Heart (interactive with confetti + details)
                ZStack {
                    if showConfetti {
                        ConfettiView()
                            .frame(width: 200, height: 200)
                            .transition(.opacity)
                    }
                    
                    Image(systemName: "heart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                        .scaleEffect(showHeart ? 1.2 : 1.0)
                        .shadow(color: .white.opacity(0.7), radius: 20)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                                showHeart.toggle()
                                showDetails.toggle()
                            }
                            triggerConfetti()
                        }
                }
                
                // 📜 Expandable Details Section
                if showDetails {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("""
                        Welcome to **LifeFlow** – your trusted Smart Blood Donation System made by **Anindya Mukhopadhyay** ❤️
                        
                        Our mission is to connect life-saving donors with those in urgent need.  
                        Whether you're a hospital looking for a match, or a donor willing to help, LifeFlow simplifies the process:
                        
                        ✅ Real-time requests  
                        ✅ Uber-style pickups  
                        ✅ Verified Hospitals  
                        ✅ Verified Donors  
                        ✅ Intelligent matching engine  
                        ✅ Secure & privacy-first platform
                        """)
                        .font(.system(size: 16, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.black.opacity(0.3)))
                        .shadow(radius: 8)
                    }
                    .padding(.horizontal, 20)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
                Spacer()
            }
        }
    }
    
    // MARK: - Typing Effect
    private func typeWriter() {
        animatedText = ""
        var delay = 0.0
        for char in fullText {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                animatedText.append(char)
            }
            delay += 0.05
        }
    }
    
    // MARK: - Heartbeat Animation
    private func startHeartbeat() {
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            animateLine.toggle()
        }
    }
    
    // MARK: - Confetti Trigger
    private func triggerConfetti() {
        showConfetti = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation {
                showConfetti = false
            }
        }
    }
}

// MARK: - Heartbeat Shape
struct HeartbeatShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midY = rect.midY
        let width = rect.width
        
        path.move(to: CGPoint(x: 0, y: midY))
        
        // Flat
        path.addLine(to: CGPoint(x: width * 0.2, y: midY))
        
        // Spike 1
        path.addLine(to: CGPoint(x: width * 0.25, y: midY - 60))
        path.addLine(to: CGPoint(x: width * 0.3, y: midY + 60))
        path.addLine(to: CGPoint(x: width * 0.35, y: midY))
        
        // Flat
        path.addLine(to: CGPoint(x: width * 0.6, y: midY))
        
        // Spike 2
        path.addLine(to: CGPoint(x: width * 0.65, y: midY - 40))
        path.addLine(to: CGPoint(x: width * 0.7, y: midY))
        
        // Flat End
        path.addLine(to: CGPoint(x: width, y: midY))
        
        return path
    }
}

// MARK: - Confetti System
struct ConfettiView: View {
    @State private var particles: [Particle] = []
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: 10, height: 10)
                    .position(particle.position)
                    .opacity(particle.opacity)
            }
        }
        .onAppear {
            generateConfetti()
        }
    }
    
    private func generateConfetti() {
        particles = (0..<20).map { _ in
            Particle.random()
        }
        
        withAnimation(.easeOut(duration: 1.0)) {
            for i in particles.indices {
                particles[i].position.y -= CGFloat.random(in: 50...150)
                particles[i].position.x += CGFloat.random(in: -100...100)
                particles[i].opacity = 0
            }
        }
    }
}

// MARK: - Particle Model
struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint = CGPoint(x: 100, y: 100)
    var color: Color
    var opacity: Double = 1.0
    
    static func random() -> Particle {
        Particle(
            position: CGPoint(x: 100, y: 100),
            color: [Color.red, .blue, .green, .yellow, .purple, .orange].randomElement()!
        )
    }
}

//#Preview {
//    AboutUsView()
//}

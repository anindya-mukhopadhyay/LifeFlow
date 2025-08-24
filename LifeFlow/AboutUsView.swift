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
    
    // 🌟 Logo Pulse + Rotation
    @State private var pulseLogo = false
    @State private var rotation = 0.0
    
    // 🌓 Detect system Dark/Light mode
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // 🌈 Animated Gradient Background (Indian Flag colors)
            LinearGradient(
                gradient: Gradient(colors: [.orange, .orange, .white, .white, .green, .green]),
                startPoint: gradientShift ? .topLeading : .bottomTrailing,
                endPoint: gradientShift ? .bottomTrailing : .topLeading
            )
            .opacity(colorScheme == .dark ? 0.3 : 1.0)   // darker feel at night
            .background(colorScheme == .dark ? Color.black : Color.white) // base color
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 10).repeatForever(autoreverses: true), value: gradientShift)
            .onAppear {
                gradientShift.toggle()
                typeWriter()
                startHeartbeat()
                startLogoPulse()
                startRotation()
            }
            
            VStack(spacing: 30) {
                // ✍️ Typing Mission Statement
                Text(animatedText)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(colorScheme == .dark ? .white : .black) // adaptive
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                // 📈 Heartbeat Line
                HeartbeatShape()
                    .trim(from: 0, to: animateLine ? 1 : 0)
                    .stroke(colorScheme == .dark ? .white : .black,
                            style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                    .frame(height: 150)
                    .padding(.horizontal, 30)
                
                // ❤️ Rotating + Pulsating Logo (interactive)
                ZStack {
                    if showConfetti {
                        ConfettiView()
                            .frame(width: 180, height: 180)
                            .transition(.opacity)
                    }
                    
                    Image("Ashok_Chakra")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                        .rotationEffect(.degrees(rotation))   // 🔄 Continuous rotation
                        .scaleEffect(pulseLogo ? 1.2 : 1.0)   // 💓 Pulse
                        .scaleEffect(showHeart ? 1.2 : 1.0)   // On tap scaling
                        .shadow(color: .white.opacity(colorScheme == .dark ? 0.8 : 0.4), radius: 20)
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
                        """)
                        .font(.system(size: 16, design: .rounded))
                        .foregroundColor(colorScheme == .dark ? .white : .black) // adaptive
                        .multilineTextAlignment(.leading)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                        )
                        .shadow(color: .black.opacity(0.4), radius: 8)
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
    
    // MARK: - Logo Pulse
    private func startLogoPulse() {
        withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
            pulseLogo.toggle()
        }
    }
    
    // MARK: - Continuous Rotation
    private func startRotation() {
        withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
            rotation = 360
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

#Preview {
    AboutUsView()
}

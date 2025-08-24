import SwiftUI

struct AboutUsView: View {
    @State private var animateHeartbeat = false
    @State private var showConfetti = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.red.opacity(0.8), .black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                
                // MARK: - Heartbeat Line
                HeartbeatLine()
                    .stroke(Color.red, lineWidth: 3)
                    .frame(height: 100)
                    .padding(.horizontal)
                    .overlay(
                        Image(systemName: "heart.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.red)
                            .scaleEffect(animateHeartbeat ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: animateHeartbeat)
                            .onAppear { animateHeartbeat = true }
                            .offset(x: 120, y: -20)
                    )
                
                // MARK: - Title
                Text("Our Mission")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                
                // MARK: - Description
                Text("To build a world where no life is lost due to a shortage of blood. Through innovation, transparency, and compassion, we aim to make blood donation more accessible, efficient, and safe.")
                    .font(.system(size: 18, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(.ultraThinMaterial.opacity(0.3))
                    .cornerRadius(20)
                    .padding(.horizontal)
                
                // MARK: - Interactable Heart
                Button(action: {
                    withAnimation {
                        showConfetti.toggle()
                    }
                }) {
                    Image(systemName: "heart.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.red)
                        .shadow(radius: 10)
                        .scaleEffect(showConfetti ? 1.3 : 1.0)
                        .animation(.spring(), value: showConfetti)
                }
                .overlay(
                    ConfettiView()
                        .opacity(showConfetti ? 1 : 0)
                        .animation(.easeInOut, value: showConfetti)
                )
            }
            .padding()
        }
    }
}

// MARK: - Heartbeat Shape
struct HeartbeatLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midY = rect.midY
        
        path.move(to: CGPoint(x: 0, y: midY))
        path.addLine(to: CGPoint(x: rect.width * 0.2, y: midY))
        path.addLine(to: CGPoint(x: rect.width * 0.3, y: midY - 40))
        path.addLine(to: CGPoint(x: rect.width * 0.4, y: midY + 40))
        path.addLine(to: CGPoint(x: rect.width * 0.5, y: midY))
        path.addLine(to: CGPoint(x: rect.width, y: midY))
        
        return path
    }
}

// MARK: - Confetti View
struct ConfettiView: View {
    var body: some View {
        ForEach(0..<20, id: \.self) { i in
            Circle()
                .fill(Color.random)
                .frame(width: 8, height: 8)
                .offset(
                    x: CGFloat.random(in: -80...80),
                    y: CGFloat.random(in: -80...80)
                )
        }
    }
}

// MARK: - Random Color Extension
extension Color {
    static var random: Color {
        return Color(hue: .random(in: 0...1),
                     saturation: 0.8,
                     brightness: 0.9)
    }
}

#Preview {
    AboutUsView()
}

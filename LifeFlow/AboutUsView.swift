import SwiftUI

struct AboutUsView: View {
    var body: some View {
        ZStack {
            // 🌈 Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.red.opacity(0.8), Color.pink.opacity(0.7), Color.white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 25) {
                // ❤️ Icon
                Image(systemName: "drop.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                
                // Glass Card
                VStack(spacing: 20) {
                    Text("Our Mission")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    
                    Text("""
                    Hi you know that No life should ever be lost to a shortage of blood. 
                    Through innovation, transparency, and compassion, 
                    we make blood donation safer, more accessible, 
                    and more efficient — because every drop counts.
                    """)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black.opacity(0.8))
                        .font(.system(size: 18, weight: .medium))
                        .padding()
                }
                .padding()
                .frame(maxWidth: 350)
                .background(.ultraThinMaterial)
                .cornerRadius(25)
                .shadow(color: .red.opacity(0.3), radius: 15, x: 0, y: 10)
                .padding()
                
                // 🌟 Call to Action Button
                Button(action: {
                    // Future navigation (maybe to donor registration)
                }) {
                    Text("Join the Mission")
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(radius: 8)
                }
                .padding(.horizontal, 40)
            }
            .padding()
        }
    }
}

//#Preview {
//    AboutUsView()
//}

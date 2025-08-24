import SwiftUI

struct AboutUsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                
                // Header with gradient background
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color.red.opacity(0.9), Color.pink.opacity(0.8)]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .shadow(radius: 8)
                    
                    VStack(spacing: 10) {
                        Image(systemName: "drop.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                        Text("About LifeLine")
                            .font(.title.bold())
                            .foregroundColor(.white)
                        Text("Every Drop Counts")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Mission Statement Card
                VStack(alignment: .leading, spacing: 16) {
                    Text("Our Mission")
                        .font(.headline)
                        .foregroundColor(.red)
                    
                    Text("No life should ever be lost to a shortage of blood. Through innovation, transparency, and compassion, we make blood donation safer, more accessible, and more efficient — because every drop counts.")
                        .font(.body)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                .padding(.horizontal)
                
                // Vision / Values Section
                VStack(alignment: .leading, spacing: 20) {
                    Text("Our Values")
                        .font(.headline)
                        .foregroundColor(.red)
                    
                    HStack(alignment: .top, spacing: 15) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.yellow)
                            .font(.title2)
                        Text("Innovation — Leveraging technology to simplify and transform the donation process.")
                            .font(.subheadline)
                    }
                    
                    HStack(alignment: .top, spacing: 15) {
                        Image(systemName: "person.2.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                        Text("Compassion — Putting people first and building trust in every interaction.")
                            .font(.subheadline)
                    }
                    
                    HStack(alignment: .top, spacing: 15) {
                        Image(systemName: "shield.checkerboard")
                            .foregroundColor(.green)
                            .font(.title2)
                        Text("Transparency — Ensuring clarity, safety, and reliability at every step.")
                            .font(.subheadline)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                .padding(.horizontal)
                
                Spacer(minLength: 40)
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}
//#Preview {
//    AboutUsView()
//}

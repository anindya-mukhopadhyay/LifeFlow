import SwiftUI

struct AboutUsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                
                // Hero Section
                VStack(spacing: 12) {
                    Image(systemName: "drop.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.red)
                        .shadow(color: .red.opacity(0.4), radius: 10, x: 0, y: 5)
                    
                    Text("Our Mission")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("No life should ever be lost to a shortage of blood. Through innovation, transparency, and compassion, we make blood donation safer, more accessible, and more efficient — because every drop counts.")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.red.opacity(0.05))
                )
                .padding(.horizontal)
                
                // Vision Card
                VStack(spacing: 12) {
                    Text("Our Vision")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.red)
                    
                    Text("To build a world where donating blood is as seamless as sending a message — connecting lives with compassion and technology.")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 15)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                )
                .padding(.horizontal)
                
                // Call to Action
                VStack(spacing: 10) {
                    Text("Join Us")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text("Together, we can ensure that every drop saves a life.")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        // Future action e.g. Navigate to Register
                    }) {
                        Text("Become a Donor")
                            .font(.system(size: 16, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: .red.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.vertical, 20)
            }
            .padding(.top, 30)
            .padding(.bottom, 50)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("About Us")
        .navigationBarTitleDisplayMode(.inline)
    }
}
//#Preview {
//    AboutUsView()
//}

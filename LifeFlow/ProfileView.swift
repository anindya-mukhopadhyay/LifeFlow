import SwiftUI

struct ProfileView: View {
    let userName: String
    let userAge: Int

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // 🔴 Profile Image
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.red)
                    .padding(.top, 16)

                // 🔴 Name & Age
                VStack(spacing: 4) {
                    Text(userName)
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Text("Age: \(userAge)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Divider()

                // 🔴 Medical Records Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Medical Records")
                        .font(.headline)

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Label("Blood Type", systemImage: "drop.fill")
                                .foregroundColor(.red)
                            Spacer()
                            Text("A-")
                                .foregroundColor(.primary)
                        }

                        HStack {
                            Label("Last Donation", systemImage: "calendar")
                                .foregroundColor(.red)
                            Spacer()
                            Text("Jan 2024")
                                .foregroundColor(.primary)
                        }

                        HStack {
                            Label("Eligibility", systemImage: "checkmark.shield.fill")
                                .foregroundColor(.red)
                            Spacer()
                            Text("Eligible")
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                    .background(Color(.systemGroupedBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Profile")
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
}

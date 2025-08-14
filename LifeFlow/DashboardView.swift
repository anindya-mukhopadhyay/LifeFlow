import SwiftUI

struct DashboardView: View {
    @AppStorage("userName") private var userName: String = "Anindya"
    @AppStorage("userDOB") private var userDOB: Date = Date() // Store DOB instead of age
    @AppStorage("profileImageData") private var profileImageData: Data?

    // Calculate age dynamically
    private var calculatedAge: Int {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: userDOB, to: now)
        return ageComponents.year ?? 0
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // 🔵 Profile Header
                    HStack(spacing: 16) {
                        if let data = profileImageData,
                           let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 64)
                                .clipShape(Circle())
                                .padding(6)
                                .background(Color(UIColor.systemBackground))
                                .clipShape(Circle())
                                .shadow(color: Color.primary.opacity(0.2), radius: 4)
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 64, height: 64)
                                .clipShape(Circle())
                                .padding(6)
                                .background(Color(UIColor.systemBackground))
                                .clipShape(Circle())
                                .shadow(color: Color.primary.opacity(0.2), radius: 4)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(userName)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(UIColor.label))
                            
                            Text("Age: \(calculatedAge)")
                                .font(.subheadline)
                                .foregroundColor(Color(UIColor.secondaryLabel))
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // 🔵 Dashboard Cards
                    VStack(spacing: 20) {
                        DashboardCardView(title: "Profile", icon: "person.crop.circle", destination: ProfileView())
                        DashboardCardView(title: "Register as Donor", icon: "pencil.circle", destination: RegisterAsDonorView())
                        DashboardCardView(title: "Blood Bank Near Me", icon: "map.circle", destination: BloodBankNearMeView())
                        DashboardCardView(title: "Blood Requirements", icon: "exclamationmark.bubble", destination: BloodRequirementsView())
                        DashboardCardView(title: "Donation Stats", icon: "chart.bar", destination: DonationStatsView())
                        DashboardCardView(title: "Donation History", icon: "clock.fill", destination: DonationHistoryView())
                        DashboardCardView(title: "My Certificate", icon: "doc.text.fill", destination: MyCertificateView())
                        DashboardCardView(title: "Notifications", icon: "bell.fill", destination: NotificationsView())
                        DashboardCardView(title: "About Us", icon: "info.circle", destination: AboutUsView())

                        // ✅ New Options
                        DashboardCardView(title: "Chatbot & FAQ", icon: "message.fill", destination: ChatbotFAQView())
                        DashboardCardView(title: "Thalassemia", icon: "bandage.fill", destination: ThalassemiaView())
                    }
                }
                .padding(.bottom, 32)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Dashboard")
        }
    }
}

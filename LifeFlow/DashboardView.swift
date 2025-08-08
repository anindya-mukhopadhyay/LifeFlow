import SwiftUI

struct DashboardView: View {
    var userName = "Anindya"
    var userAge = 20
    var userImage = "person.crop.circle.fill"
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // 🔴 Profile Header
                    HStack(spacing: 16) {
                        Image(systemName: userImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                            .padding(6)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(userName)
                                .font(.title2)
                                .fontWeight(.semibold)
                            Text("Age: \(userAge)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // 🔴 Dashboard Cards
                    VStack(spacing: 20) {
                        DashboardCardView(title: "Profile", icon: "person.crop.circle", destination: ProfileView(userName: userName, userAge: userAge))
            
                        DashboardCardView(title: "Register as Donor", icon: "pencil.circle",destination:RegisterAsDonorView())
                        
                        //
                        DashboardCardView(title: "Blood Bank Near Me", icon: "map.circle", destination: BloodBankNearMeView())

                        DashboardCardView(title: "Blood Requirements", icon: "exclamationmark.bubble", destination: BloodRequirementsView())

                        DashboardCardView(title: "Donation Stats", icon: "chart.bar", destination: DonationStatsView())
                        
                        DashboardCardView(title: "Donation History", icon: "clock.fill",destination:DonationHistoryView())
                        }
                        DashboardCardView(title: "My Certificate", icon: "doc.text.fill",destination: MyCertificateView())
                        DashboardCardView(title: "Notifications", icon: "bell.fill",destination: NotificationsView())
                        }
                        DashboardCardView(title: "About Us", icon: "info.circle",destination: AboutUsView())
                
                
                
            }
            .padding(.bottom, 32)
        }
        .navigationTitle("Dashboard")
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    
}

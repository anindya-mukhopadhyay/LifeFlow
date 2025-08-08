import SwiftUI
import Charts

struct DonationStat: Identifiable {
    var id = UUID()
    let month: String
    let count: Int
}

struct DonationStatsView: View {
    let stats: [DonationStat] = [
        DonationStat(month: "Jan", count: 2),
        DonationStat(month: "Feb", count: 1),
        DonationStat(month: "Mar", count: 3),
        DonationStat(month: "Apr", count: 1),
        DonationStat(month: "May", count: 2),
        DonationStat(month: "Jun", count: 0),
        DonationStat(month: "Jul", count: 4)
    ]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Monthly Donation Stats")
                    .font(.title2)
                    .padding(.horizontal)

                Chart(stats) { stat in
                    BarMark(
                        x: .value("Month", stat.month),
                        y: .value("Donations", stat.count)
                    )
                    .foregroundStyle(Color.red)
                }
                .frame(height: 300)
                .padding()

                Spacer()
            }
            .navigationTitle("Donation Stats")
        }
    }
}

import SwiftUI
import Charts

struct DonationStat: Identifiable {
    var id = UUID()
    let year: String
    let count: Int
}

struct DonationStatsView: View {
    let stats: [DonationStat] = [
        DonationStat(year: "2019", count: 10),
        DonationStat(year: "2020", count: 14),
        DonationStat(year: "2021", count: 7),
        DonationStat(year: "2022", count: 15),
        DonationStat(year: "2023", count: 12)
    ]

    private let skyBlue = Color(red: 126/255, green: 200/255, blue: 227/255)

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Yearly Donation Stats")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .padding(.horizontal)

                Chart {
                    ForEach(stats) { stat in
                        AreaMark(
                            x: .value("Year", stat.year),
                            y: .value("Donations", stat.count)
                        )
                        .interpolationMethod(.catmullRom) // smooth curve
                        .foregroundStyle(
                            LinearGradient(
                                colors: [skyBlue.opacity(0.6), skyBlue.opacity(0.15)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )

                        LineMark(
                            x: .value("Year", stat.year),
                            y: .value("Donations", stat.count)
                        )
                        .interpolationMethod(.catmullRom)
                        .lineStyle(StrokeStyle(lineWidth: 3))
                        .foregroundStyle(skyBlue)
                        .symbol(Circle())
                        .symbolSize(70)
                    }
                }
                .frame(height: 320)
                .padding(.horizontal)
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .chartXAxis {
                    AxisMarks(values: stats.map { $0.year })
                }

                Spacer()
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Donation Stats")
        }
    }
}

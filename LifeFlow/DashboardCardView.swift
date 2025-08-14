import SwiftUI

struct DashboardCardView<Destination: View>: View {
    let title: String
    let icon: String
    let destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(.red) // keep brand color
                    .frame(width: 40, height: 40)
                    .background(Color.red.opacity(0.15))
                    .clipShape(Circle())

                Text(title)
                    .font(.headline)
                    .foregroundColor(Color.primary) // adapts to dark/light

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(Color(UIColor.tertiaryLabel)) // softer dynamic gray
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground)) // adapts to mode
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 4)
        }
        .padding(.horizontal)
    }
}

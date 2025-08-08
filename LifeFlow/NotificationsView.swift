//
//  NotificationsView.swift
//  Life   Flow
//
//  Created by Anindya Mukhopadhyay on 05/08/25.
//


import SwiftUI

struct NotificationItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let date: Date
    let isRead: Bool
}

struct NotificationsView: View {
    // Sample static data
    @State private var notifications: [NotificationItem] = [
        NotificationItem(title: "Urgent Blood Requirement", message: "A+ blood needed at Fortis Hospital", date: Date(), isRead: false),
        NotificationItem(title: "Donation Reminder", message: "You are now eligible to donate again!", date: Date().addingTimeInterval(-86400 * 30), isRead: true)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Notifications")
                .font(.largeTitle)
                .bold()

            if notifications.isEmpty {
                Spacer()
                VStack {
                    Image(systemName: "bell.slash")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray)
                    Text("No new notifications.")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
                Spacer()
            } else {
                ScrollView {
                    ForEach(notifications) { notification in
                        NotificationCard(notification: notification)
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Alerts")
    }
}

struct NotificationCard: View {
    let notification: NotificationItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: notification.isRead ? "envelope.open" : "envelope.badge")
                    .foregroundColor(notification.isRead ? .gray : .red)
                Text(notification.title)
                    .font(.headline)
            }

            Text(notification.message)
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text(formattedDate(notification.date))
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 4)
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

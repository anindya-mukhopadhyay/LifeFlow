////
////  EventsView.swift
////  Life   Flow
////
////  Created by Anindya Mukhopadhyay on 24/08/25.
////
//
//
//import SwiftUI
//
//struct Event: Identifiable {
//    let id = UUID()
//    let title: String
//    let date: String
//    let location: String
//    let description: String
//}
//
//struct EventsView: View {
//    @State private var events: [Event] = [
//        Event(
//            title: "Blood Donation Camp - Kolkata",
//            date: "Sep 05, 2025",
//            location: "Apollo Hospital, Kolkata",
//            description: "Organized by Red Cross. Walk-ins are welcome from 10 AM to 4 PM."
//        ),
//        Event(
//            title: "Thalassemia Awareness & Blood Drive",
//            date: "Sep 12, 2025",
//            location: "AIIMS, Delhi",
//            description: "Join us for awareness sessions followed by a donation drive."
//        ),
//        Event(
//            title: "Community Blood Camp",
//            date: "Sep 20, 2025",
//            location: "Bangalore Community Center",
//            description: "Donors will receive free health check-ups and certificates."
//        )
//    ]
//    
//    var body: some View {
//        NavigationView {
//            List(events) { event in
//                VStack(alignment: .leading, spacing: 8) {
//                    Text(event.title)
//                        .font(.headline)
//                        .foregroundColor(.red)
//                    
//                    HStack {
//                        Label(event.date, systemImage: "calendar")
//                        Label(event.location, systemImage: "mappin.and.ellipse")
//                    }
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//                    
//                    Text(event.description)
//                        .font(.body)
//                        .foregroundColor(.primary)
//                }
//                .padding(.vertical, 8)
//            }
//            .navigationTitle("Upcoming Events")
//        }
//    }
//}
//

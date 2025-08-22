//
//  BloodCompatibilityView.swift
//  Life   Flow
//
//  Created by Anindya Mukhopadhyay on 23/08/25.
//

import SwiftUI

struct BloodCompatibilityView: View {
    // Blood group compatibility data
    let bloodCompatibility: [String: (donateTo: [String], receiveFrom: [String])] = [
        "A+": (donateTo: ["A+", "AB+"], receiveFrom: ["A+", "A-", "O+", "O-"]),
        "A-": (donateTo: ["A+", "A-", "AB+", "AB-"], receiveFrom: ["A-", "O-"]),
        "B+": (donateTo: ["B+", "AB+"], receiveFrom: ["B+", "B-", "O+", "O-"]),
        "B-": (donateTo: ["B+", "B-", "AB+", "AB-"], receiveFrom: ["B-", "O-"]),
        "AB+": (donateTo: ["AB+"], receiveFrom: ["Everyone"]),
        "AB-": (donateTo: ["AB+", "AB-"], receiveFrom: ["A-", "B-", "AB-", "O-"]),
        "O+": (donateTo: ["A+", "B+", "AB+", "O+"], receiveFrom: ["O+", "O-"]),
        "O-": (donateTo: ["Everyone"], receiveFrom: ["O-"])
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("🩸 Blood Compatibility Chart")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                ForEach(bloodCompatibility.keys.sorted(), id: \.self) { bloodType in
                    if let details = bloodCompatibility[bloodType] {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Blood Group: \(bloodType)")
                                .font(.headline)
                                .foregroundColor(.red)
                            
                            Text("➡️ Can Donate To: \(details.donateTo.joined(separator: ", "))")
                                .font(.subheadline)
                                .foregroundColor(.green)
                            
                            Text("⬅️ Can Receive From: \(details.receiveFrom.joined(separator: ", "))")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.bottom, 30)
        }
        .navigationTitle("Compatibility")
    }
}

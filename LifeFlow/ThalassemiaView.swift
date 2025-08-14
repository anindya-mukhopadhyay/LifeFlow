//
//  ThalassemiaView.swift
//  Life   Flow
//
//  Created by Anindya Mukhopadhyay on 13/08/25.
//

import SwiftUI

struct ThalassemiaView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Thalassemia Information")
                    .font(.title)
                    .bold()

                Text("Thalassemia is a genetic blood disorder that affects the body's ability to produce hemoglobin. People with severe thalassemia require regular blood transfusions and are generally not eligible to donate blood.")

                Text("• If you are a carrier (minor thalassemia), you may be able to donate depending on your hemoglobin level.")
                Text("• Always consult a doctor before donating blood if you have any blood-related disorder.")
            }
            .padding()
        }
        .navigationTitle("Thalassemia")
    }
}

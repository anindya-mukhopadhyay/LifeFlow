//
//  AboutUsView.swift
//  LifeFlow
//  Created by Anindya Mukhopadhyay on 05/08/25.
//

import SwiftUI

struct AboutUsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                
                // App Logo / Icon
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.1))
                        .frame(width: 140, height: 140)
                    
                    Image(systemName: "drop.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.red)
                }
                .padding(.top, 20)
                
                // Intro / Mission
                VStack(alignment: .leading, spacing: 12) {
                    Text("Welcome to **LifeFlow**")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    
                    Text("""
Your trusted Smart Blood Donation System made by **Anindya Mukhopadhyay**.  

Our mission is simple yet powerful: to connect life-saving donors with those in urgent need. Whether you’re a hospital searching for a match or a donor ready to help, **LifeFlow makes the process seamless, safe, and reliable**.
""")
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 20).fill(Color(.systemGray6)))
                .shadow(radius: 2)
                
                // Features
                VStack(alignment: .leading, spacing: 12) {
                    Text("Why LifeFlow?")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.red)
                    
                    FeatureRow(icon: "bolt.fill", text: "Real-time requests")
                    FeatureRow(icon: "car.fill", text: "Uber-style pickups")
                    FeatureRow(icon: "cross.case.fill", text: "Verified Hospitals")
                    FeatureRow(icon: "heart.text.square.fill", text: "Verified Donors")
                    FeatureRow(icon: "brain.head.profile", text: "Intelligent Matching Engine")
                    FeatureRow(icon: "lock.shield.fill", text: "Secure & Privacy-first Platform")
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 20).fill(Color(.systemGray6)))
                .shadow(radius: 2)
                
                // Vision
                VStack(alignment: .leading, spacing: 12) {
                    Text("Our Vision")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.red)
                    
                    Text("""
No life should ever be lost to a shortage of blood.  
Through **innovation, transparency, and compassion**, we make blood donation **safer, more accessible, and more efficient** — because **every drop counts**.
""")
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 20).fill(Color(.systemGray6)))
                .shadow(radius: 2)
                
                // Contact
                VStack(alignment: .leading, spacing: 8) {
                    Text("Contact Us")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.red)
                    
                    HStack {
                        Image(systemName: "envelope.fill").foregroundColor(.red)
                        Text("youanindya1@gmail.com")
                    }
                    
                    HStack {
                        Image(systemName: "globe").foregroundColor(.red)
                        Text("www.lifeflow.com")
                    }
                    
                    HStack {
                        Image(systemName: "mappin.and.ellipse").foregroundColor(.red)
                        Text("Newtown, Kolkata, West Bengal, India")
                    }
                }
                .font(.subheadline)
                .padding()
                .background(RoundedRectangle(cornerRadius: 20).fill(Color(.systemGray6)))
                .shadow(radius: 2)
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationTitle("About Us")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Reusable Feature Row
struct FeatureRow: View {
    var icon: String
    var text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.red)
                .frame(width: 24, height: 24)
            Text(text)
                .foregroundColor(.primary)
            Spacer()
        }
    }
}

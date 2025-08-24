//
//  AboutUsView.swift
//  LifeFlow
//  Created by Anindya Mukhopadhyay on 05/08/25.
//

import SwiftUI

struct AboutUsView: View {
    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(gradient: Gradient(colors: [Color.red.opacity(0.2), Color.white]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    
                    // Logo with Glow
                    ZStack {
                        Circle()
                            .fill(Color.red.opacity(0.15))
                            .frame(width: 160, height: 160)
                            .blur(radius: 12)
                        
                        Image(systemName: "drop.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.red)
                    }
                    .padding(.top, 40)
                    
                    // Welcome Section
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Welcome to LifeFlow")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                            
                            Text("""
A trusted Smart Blood Donation System by **Anindya Mukhopadhyay**.  

We connect life-saving donors with those in urgent need.  
Whether you’re a hospital searching for blood or a donor willing to help, **LifeFlow makes the journey seamless, safe, and reliable.**
""")
                        }
                    }
                    
                    // Features Section
                    GlassCard {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Why LifeFlow?")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.red)
                            
                            FeatureRow(icon: "bolt.fill", text: "Real-time requests")
                            FeatureRow(icon: "car.fill", text: "Uber-style pickups")
                            FeatureRow(icon: "cross.case.fill", text: "Verified Hospitals")
                            FeatureRow(icon: "heart.text.square.fill", text: "Verified Donors")
                            FeatureRow(icon: "brain.head.profile", text: "Intelligent Matching Engine")
                            FeatureRow(icon: "lock.shield.fill", text: "Secure & Privacy-first Platform")
                        }
                    }
                    
                    // Vision Section
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Our Vision")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.red)
                            
                            Text("""
No life should ever be lost due to a shortage of blood.  
Through **innovation, transparency, and compassion**, we make blood donation **safer, more accessible, and more efficient** — because **every drop counts**.
""")
                        }
                    }
                    
                    // Contact Section
                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Contact Us")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.red)
                            
                            ContactRow(icon: "envelope.fill", text: "youanindya1@gmail.com")
                            ContactRow(icon: "globe", text: "www.lifeflow.com")
                            ContactRow(icon: "mappin.and.ellipse", text: "Newtown, Kolkata, West Bengal, India")
                        }
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("About Us")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Reusable Glass Card
struct GlassCard<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            content
        }
        .padding()
        .background(.ultraThinMaterial) // Glass effect
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Feature Row
struct FeatureRow: View {
    var icon: String
    var text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.red)
                .frame(width: 22, height: 22)
            Text(text)
            Spacer()
        }
        .font(.body)
    }
}

// MARK: - Contact Row
struct ContactRow: View {
    var icon: String
    var text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.red)
                .frame(width: 22, height: 22)
            Text(text)
        }
        .font(.subheadline)
    }
}

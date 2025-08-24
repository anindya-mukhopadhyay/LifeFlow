//
//  AboutUsView.swift
//  LifeFlow
//  Created by Anindya Mukhopadhyay on 05/08/25.
//

import SwiftUI

struct AboutUsView: View {
    @State private var animateLogo = false
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            // Animated Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [Color.red.opacity(0.2), Color.white]),
                startPoint: animateLogo ? .topLeading : .bottomTrailing,
                endPoint: animateLogo ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: animateLogo)
            
            ScrollView {
                VStack(spacing: 30) {
                    
                    // Logo with Animated Glow
                    ZStack {
                        Circle()
                            .fill(Color.red.opacity(0.2))
                            .frame(width: animateLogo ? 180 : 160, height: animateLogo ? 180 : 160)
                            .blur(radius: 15)
                            .opacity(animateLogo ? 0.6 : 0.3)
                            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateLogo)
                        
                        Image(systemName: "drop.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                            .foregroundColor(.red)
                            .scaleEffect(animateLogo ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animateLogo)
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
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 40)
                    .animation(.easeOut(duration: 1).delay(0.3), value: showContent)
                    
                    // Features Section
                    GlassCard {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Why LifeFlow?")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.red)
                            
                            ForEach(Array(features.enumerated()), id: \.offset) { index, feature in
                                FeatureRow(icon: feature.icon, text: feature.text)
                                    .opacity(showContent ? 1 : 0)
                                    .offset(x: showContent ? 0 : -30)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2 + Double(index) * 0.1), value: showContent)
                            }
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
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 40)
                    .animation(.easeOut(duration: 1).delay(0.6), value: showContent)
                    
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
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 40)
                    .animation(.easeOut(duration: 1).delay(0.9), value: showContent)
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
            }
        }
        .onAppear {
            animateLogo = true
            showContent = true
        }
        .navigationTitle("About Us")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Features Data
let features: [(icon: String, text: String)] = [
    ("bolt.fill", "Real-time requests"),
    ("car.fill", "Uber-style pickups"),
    ("cross.case.fill", "Verified Hospitals"),
    ("heart.text.square.fill", "Verified Donors"),
    ("brain.head.profile", "Intelligent Matching Engine"),
    ("lock.shield.fill", "Secure & Privacy-first Platform")
]

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
        .background(.ultraThinMaterial)
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

#Preview {
    AboutUsView()
}

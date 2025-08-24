//
//  AboutUsView.swift
//  LifeFlow
//  Created by Anindya Mukhopadhyay on 05/08/25.
//

import SwiftUI
import UIKit // Needed for UIBezierPath & UIRectCorner

struct AboutUsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                // Top Hero Section
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.red, Color.red.opacity(0.8)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 250)
                    .clipShape(RoundedCornerShape(corners: [.bottomLeft, .bottomRight], radius: 40))
                    
                    VStack(spacing: 12) {
                        Image(systemName: "drop.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.white)
                            .shadow(radius: 8)
                        
                        Text("LifeFlow")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Smart Blood Donation System")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.top, 30)
                }
                
                // Content Sections
                VStack(spacing: 30) {
                    
                    // Intro
                    SectionCard(title: "Welcome", content: """
A trusted Smart Blood Donation System by **Anindya Mukhopadhyay**.

We connect life-saving donors with those in urgent need.
Whether you’re a hospital searching for blood or a donor ready to help, **LifeFlow makes the journey seamless, safe, and reliable.**
""")
                    
                    // Features
                    SectionCard(title: "Why LifeFlow?") {
                        VStack(alignment: .leading, spacing: 14) {
                            FeatureRow(icon: "bolt.fill", text: "Real-time requests")
                            FeatureRow(icon: "car.fill", text: "Uber-style pickups")
                            FeatureRow(icon: "cross.case.fill", text: "Verified Hospitals")
                            FeatureRow(icon: "heart.text.square.fill", text: "Verified Donors")
                            // If you target < iOS 17, prefer a safer symbol than "brain.head.profile"
                            FeatureRow(icon: "brain.head.profile", text: "Intelligent Matching Engine")
                            FeatureRow(icon: "lock.shield.fill", text: "Secure & Privacy-first Platform")
                        }
                    }
                    
                    // Vision
                    SectionCard(title: "Our Vision", content: """
No life should ever be lost due to a shortage of blood.
Through **innovation, transparency, and compassion**, we make blood donation **safer, more accessible, and more efficient** — because every drop counts.
""")
                    
                    // Contact
                    SectionCard(title: "Contact Us") {
                        VStack(alignment: .leading, spacing: 10) {
                            ContactRow(icon: "envelope.fill", text: "youanindya1@gmail.com")
                            ContactRow(icon: "globe", text: "www.lifeflow.com")
                            ContactRow(icon: "mappin.and.ellipse", text: "Newtown, Kolkata, West Bengal, India")
                        }
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Section Card (fixed generics)
struct SectionCard<Content: View>: View {
    let title: String
    let contentText: String?
    @ViewBuilder let contentView: Content
    
    // Text-only initializer (Content == EmptyView)
    init(title: String, content: String) where Content == EmptyView {
        self.title = title
        self.contentText = content
        self.contentView = EmptyView()
    }
    
    // Custom-content initializer
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.contentText = nil
        self.contentView = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.red)
            
            if let text = contentText {
                Text(text)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            
            contentView // EmptyView for text-only cards; a real view otherwise.
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
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
                .frame(width: 24, height: 24)
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

// MARK: - Custom Rounded Shape for Hero
struct RoundedCornerShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

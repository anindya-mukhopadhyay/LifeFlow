//  AboutUsView.swift
//  Life   Flow
//  Created by Anindya Mukhopadhyay on 05/08/25.
//
import SwiftUI
struct AboutUsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(systemName: "drop.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.red)
                    .padding(.bottom, 10)

                Text("""
Welcome to **LifeFlow** – your trusted Smart Blood Donation System made by **Anindya Mukhopadhyay** 

Our mission is to connect life-saving donors with those in urgent need. Whether you're a hospital looking for a match, or a donor willing to help, LifeDrop simplifies the process.

✅ Real-time requests  
✅ Uber-style pickups  
✅ Verified hospitals & donors  
✅ Intelligent matching engine  
✅ Secure & privacy-first platform
""")
                    .font(.body)
                    .padding(.bottom, 10)

                Text("Our Vision")
                    .font(.title2)
                    .bold()

                Text("""
To build a world where no life is lost due to a shortage of blood. Through innovation, transparency, and compassion, we aim to make blood donation more accessible, efficient, and safe.
""")

                Text("Contact Us")
                    .font(.title2)
                    .bold()
                    .padding(.top)

                VStack(alignment: .leading, spacing: 6) {
                    Text("📧 Email: youanindya1@gmail.com")
                    Text("🌐 Website: www.lifeflow.com")
                    Text("**📍 Location: Newtown,Kolkata, West Bengal,India**")
                }
                .font(.subheadline)
                .foregroundColor(.gray)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("About Us")
    }
}


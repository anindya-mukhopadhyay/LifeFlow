🩸 LifeFlow – Smart Blood Donation App
<p align="center"> <img src="https://img.shields.io/badge/Platform-iOS-red?style=for-the-badge&logo=apple" /> <img src="https://img.shields.io/badge/SwiftUI-Enabled-orange?style=for-the-badge&logo=swift" /> <img src="https://img.shields.io/badge/Firebase-Backend-yellow?style=for-the-badge&logo=firebase" /> <img src="https://img.shields.io/badge/Status-Active-brightgreen?style=for-the-badge" /> </p> <p align="center"> 🚑 <b>LifeFlow</b> is a next-gen Smart Blood Donation System that connects donors, hospitals, and patients seamlessly. It includes real-time matching, Uber-style donor pickup, donation history, and an engaging iOS SwiftUI experience. </p>
✨ Features

🔐 Role-Based Login – Separate dashboards for Users, Hospitals, and Admins

🩸 Blood Requirements – View, filter, and manage urgent blood needs

📍 Nearby Blood Banks – Real-time location with Google Places integration

🚕 Smart Donor Pickup – Uber-style cab booking for eligible donors

📊 Donation Stats & History – Track your contributions with beautiful charts

⚡ Push Notifications – Instant alerts for matching blood requirements

🛡️ Secure Authentication – Powered by Firebase Auth & Firestore

📱 App Workflow
flowchart TD
    A[Login / Signup] -->|Role: User| B[User Dashboard]
    A -->|Role: Hospital| C[Hospital Dashboard]
    A -->|Role: Admin| D[Admin Dashboard]

    B --> E[See Requirements]
    B --> F[Register as Donor]
    B --> G[Donation Stats & History]

    C --> H[Post Blood Requirement]
    C --> I[Match Donors]

    B --> J[Nearby Blood Banks]
    H --> K[Smart Pickup Request]
    K --> L[Cab Auto-Booking]

🛠️ Tech Stack

Frontend: SwiftUI (iOS 16+)

Backend: Firebase (Auth, Firestore, Notifications)

Maps & Location: MapKit + Google Places API

Design: Apple Human Interface Guidelines + Custom UI Components

🚀 Getting Started
Prerequisites

macOS with Xcode 15+

Swift 5.9+

Firebase Project Setup (Firestore + Authentication)

Installation
# Clone the repository
git clone https://github.com/yourusername/lifeflow.git

# Open in Xcode
cd lifeflow
open LifeFlow.xcodeproj

Setup

Add your GoogleService-Info.plist in the project root

Enable Firebase Auth & Firestore

Run on iOS Simulator or real device

📸 Screenshots
<p ## 📸 Screenshots


## 📸 Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/5c595663-3b1e-49e5-8e08-edf0447589bd" alt="Dashboard" width="250" />
  <img src="https://github.com/user-attachments/assets/e83c6a09-8869-43bd-99ae-0c87d1e3e255" alt="Blood Banks Near Me" width="250" />
  <img src="https://github.com/user-attachments/assets/b45f7be0-f9ee-46c7-a204-70640a3300f0" alt="Settings" width="250" />
  <img src="https://github.com/user-attachments/assets/2b3e8785-6742-4230-887e-0c2b653a3804" alt="App UI" width="250" />
</p>

🤝 Contributing

We welcome contributions!

Fork the repo

Create a feature branch (feature/new-feature)

Commit & Push

Open a Pull Request 🎉

📜 License

This project is licensed under the MIT License.

<p align="center"> 💡 Built with ❤️ by <b>Anindya</b> </p>

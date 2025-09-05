
import SwiftUI
import UIKit
import FirebaseAuth
import FirebaseFirestore

// MARK: - ProfileView
struct ProfileView: View {
    // 🔧 Cloudinary
    private let cloudName = "djoaxuvqs"
    private let uploadPreset = "LifeFlow"

    // Fields
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var address: String = ""
    @State private var pincode: String = ""
    @State private var city: String = ""
    @State private var emergencyNumber: String = ""
    @State private var bloodGroup: String = "A+"
    @State private var dob: Date = Date()
    @State private var lastDonation: Date = Date()
    @State private var age: Int = 0

    // Image
    @State private var selectedImage: UIImage?
    @State private var uploadedImageURL: String?
    @State private var showingImagePicker = false
    @State private var isUploading = false

    // UI
    @State private var isEditing: Bool = false
    @State private var message: String = ""

    private let db = Firestore.firestore()
    private let bloodGroups = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]

    var body: some View {
        ZStack {
            // Background: light/dark adaptive gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.red.opacity(0.2),
                    Color(.systemBackground)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // MARK: Profile Image
                    VStack {
                        ZStack {
                            if let selectedImage = selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 130, height: 130)
                                    .clipShape(Circle())
                            } else if let urlStr = uploadedImageURL, let url = URL(string: urlStr) {
                                AsyncImage(url: url) { img in
                                    img.resizable().scaledToFill()
                                } placeholder: { ProgressView() }
                                .frame(width: 130, height: 130)
                                .clipShape(Circle())
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 130, height: 130)
                                    .overlay(Image(systemName: "person.fill").font(.largeTitle).foregroundColor(.secondary))
                            }
                        }
                        .overlay(Circle().stroke(Color.red, lineWidth: 4))
                        .shadow(radius: 8)

                        if isEditing {
                            Button {
                                showingImagePicker = true
                            } label: {
                                Label("Change Photo", systemImage: "camera.fill")
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding(.top, 8)
                        }
                    }
                    .padding(.top, 40)

                    if isUploading { ProgressView("Uploading...") }

                    // MARK: Info Card
                    VStack(spacing: 16) {
                        ProfileRow(title: "Name", text: $name, isEditing: isEditing, icon: "person.fill")
                        ProfileRow(title: "Email", text: $email, isEditing: false, icon: "envelope.fill")
                        ProfileRow(title: "Phone", text: $phone, isEditing: isEditing, icon: "phone.fill")
                        ProfileRow(title: "Address", text: $address, isEditing: isEditing, icon: "house.fill")
                        ProfileRow(title: "Pincode", text: $pincode, isEditing: isEditing, icon: "mappin.and.ellipse")
                        ProfileRow(title: "City", text: $city, isEditing: isEditing, icon: "building.2.fill")
                        ProfileRow(title: "Emergency Contact", text: $emergencyNumber, isEditing: isEditing, icon: "phone.badge.plus")

                        // Blood Group
                        HStack {
                            Image(systemName: "drop.fill").foregroundColor(.red).frame(width: 30)
                            if isEditing {
                                Picker("Blood Group", selection: $bloodGroup) {
                                    ForEach(bloodGroups, id: \.self) { Text($0) }
                                }
                                .pickerStyle(MenuPickerStyle())
                            } else {
                                Text(bloodGroup).font(.body)
                            }
                        }

                        // DOB
                        HStack {
                            Image(systemName: "calendar").foregroundColor(.blue).frame(width: 30)
                            if isEditing {
                                DatePicker("DOB", selection: $dob, displayedComponents: .date)
                                    .onChange(of: dob) { _ in calculateAge() }
                            } else {
                                VStack(alignment: .leading) {
                                    Text("DOB").font(.caption).foregroundColor(.secondary)
                                    Text("\(dob.formatted(date: .abbreviated, time: .omitted))")
                                }
                            }
                        }

                        // Age
                        HStack {
                            Image(systemName: "number.circle").foregroundColor(.orange).frame(width: 30)
                            Text("Age: \(age)")
                        }

                        // Last Donation
                        HStack {
                            Image(systemName: "drop.circle.fill").foregroundColor(.blue).frame(width: 30)
                            if isEditing {
                                DatePicker("Last Donation", selection: $lastDonation, displayedComponents: .date)
                            } else {
                                VStack(alignment: .leading) {
                                    Text("Last Donation").font(.caption).foregroundColor(.secondary)
                                    Text("\(lastDonation.formatted(date: .abbreviated, time: .omitted))")
                                }
                            }
                        }

                        if isEditing {
                            Button(action: saveProfile) {
                                Label("Save Changes", systemImage: "checkmark.circle.fill")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                    .shadow(radius: 4)
                            }
                        }
                    }
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(16)
                    .shadow(radius: 4)

                    // Toggle edit
                    Button(isEditing ? "Cancel" : "Edit Profile") {
                        withAnimation(.easeInOut) { isEditing.toggle() }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(12)

                    // Message
                    if !message.isEmpty {
                        Text(message)
                            .foregroundColor(message.contains("✅") ? .green : .red)
                            .padding(.top, 4)
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear(perform: loadProfile)
        .sheet(isPresented: $showingImagePicker) {
            ProfileImagePicker(image: $selectedImage) { img in
                uploadImageToCloudinary(img) { url in
                    self.uploadedImageURL = url
                }
            }
        }
    }

    // MARK: - Helpers
    private func calculateAge() {
        let cal = Calendar.current
        age = cal.dateComponents([.year], from: dob, to: Date()).year ?? 0
    }

    private func loadProfile() {
        guard let user = Auth.auth().currentUser else { return }
        email = user.email ?? ""
        db.collection("users").document(user.uid).getDocument { doc, _ in
            if let doc = doc, doc.exists {
                self.name = doc["name"] as? String ?? ""
                self.phone = doc["phone"] as? String ?? ""
                self.address = doc["address"] as? String ?? ""
                self.pincode = doc["pincode"] as? String ?? ""
                self.city = doc["city"] as? String ?? ""
                self.emergencyNumber = doc["emergencyNumber"] as? String ?? ""
                self.bloodGroup = doc["bloodGroup"] as? String ?? "A+"
                self.uploadedImageURL = doc["photoURL"] as? String
                if let ts = doc["dob"] as? Timestamp { self.dob = ts.dateValue() }
                if let ts = doc["lastDonation"] as? Timestamp { self.lastDonation = ts.dateValue() }
                self.calculateAge()
            }
        }
    }

    private func saveProfile() {
        guard let user = Auth.auth().currentUser else { return }
        calculateAge()
        var data: [String: Any] = [
            "name": name,
            "email": email,
            "phone": phone,
            "address": address,
            "pincode": pincode,
            "city": city,
            "emergencyNumber": emergencyNumber,
            "bloodGroup": bloodGroup,
            "dob": Timestamp(date: dob),
            "lastDonation": Timestamp(date: lastDonation),
            "age": age
        ]
        if let url = uploadedImageURL { data["photoURL"] = url }

        db.collection("users").document(user.uid).setData(data, merge: true) { err in
            if let err = err {
                self.message = "❌ \(err.localizedDescription)"
            } else {
                self.message = "✅ Profile updated!"
                self.isEditing = false
            }
        }
    }

    private func uploadImageToCloudinary(_ image: UIImage, completion: @escaping (String) -> Void) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        let url = URL(string: "https://api.cloudinary.com/v1_1/\(cloudName)/image/upload")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"upload_preset\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(uploadPreset)\r\n".data(using: .utf8)!)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"profile.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { resData, _, error in
            if let error = error {
                print("❌ Upload error: \(error.localizedDescription)")
                return
            }
            guard let resData = resData else { return }
            if let json = try? JSONSerialization.jsonObject(with: resData) as? [String: Any],
               let url = json["secure_url"] as? String {
                DispatchQueue.main.async { completion(url) }
            }
        }.resume()
    }
}

// MARK: - Profile Row
struct ProfileRow: View {
    var title: String
    @Binding var text: String
    var isEditing: Bool
    var icon: String

    var body: some View {
        HStack {
            Image(systemName: icon).foregroundColor(.red).frame(width: 30)
            if isEditing {
                TextField(title, text: $text).textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                VStack(alignment: .leading) {
                    Text(title).font(.caption).foregroundColor(.secondary)
                    Text(text.isEmpty ? "Not set" : text)
                }
            }
        }
    }
}

// MARK: - Image Picker
struct ProfileImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var onPicked: (UIImage) -> Void

    func makeCoordinator() -> Coordinator { Coordinator(self, onPicked: onPicked) }
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        return picker
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ProfileImagePicker
        let onPicked: (UIImage) -> Void
        init(_ parent: ProfileImagePicker, onPicked: @escaping (UIImage) -> Void) {
            self.parent = parent; self.onPicked = onPicked
        }
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let img = (info[.editedImage] ?? info[.originalImage]) as? UIImage
            if let img = img {
                parent.image = img; onPicked(img)
            }
            picker.dismiss(animated: true)
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { picker.dismiss(animated: true) }
    }
}

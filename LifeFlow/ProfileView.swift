//import SwiftUI
//import Foundation
//import UIKit
//
//struct ProfileView: View {
//    // MARK: - Persistent storage
//    @AppStorage("userName") private var name: String = "Anindya Mukhopadhyay"
//    @AppStorage("userEmail") private var email: String = "you@example.com"
//    @AppStorage("userPhone") private var phone: String = ""
//    @AppStorage("userAddress") private var address: String = ""
//    @AppStorage("userPincode") private var pincode: String = ""
//    @AppStorage("emergencyContactNumber") private var emergencyNumber: String = ""
//    @AppStorage("emergencyContactRelation") private var emergencyRelation: String = "Mother"
//    @AppStorage("userBloodGroup") private var bloodGroup: String = "A-"
//    @AppStorage("userDOB") private var dob: Date = Date()
//    @AppStorage("profileImageData") private var profileImageData: Data?
//
//    // MARK: - View states
//    @State private var showingImagePicker = false
//    @State private var editingProfile = false
//    
//    // MARK: - Options
//    private let bloodGroups = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
//    private let relations = ["Mother", "Father", "Brother", "Sister", "Grandfather", "Grandmother", "GF", "BF", "Husband", "Wife"]
//
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 24) {
//                
//                // MARK: Profile Image
//                ZStack(alignment: .bottomTrailing) {
//                    if let data = profileImageData,
//                       let uiImage = UIImage(data: data) {
//                        Image(uiImage: uiImage)
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 120, height: 120)
//                            .clipShape(Circle())
//                    } else {
//                        Image(systemName: "person.crop.circle.fill")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 120, height: 120)
//                            .foregroundColor(.red)
//                    }
//                    
//                    Button(action: { showingImagePicker = true }) {
//                        Image(systemName: "camera.fill")
//                            .foregroundColor(.white)
//                            .padding(8)
//                            .background(Color.red)
//                            .clipShape(Circle())
//                    }
//                }
//                .padding(.top, 16)
//                
//                if editingProfile {
//                    // MARK: Editable fields
//                    Group {
//                        validatedTextField("Name", text: $name, maxLength: 30)
//                        validatedTextField("Email", text: $email, maxLength: 50, keyboard: .emailAddress)
//                        
//                        HStack {
//                            prefixBox("+91")
//                            validatedTextField("Phone Number", text: $phone, maxLength: 10, numbersOnly: true, keyboard: .numberPad)
//                        }
//                        
//                        validatedTextField("Address", text: $address, maxLength: 50)
//                        validatedTextField("Pincode", text: $pincode, maxLength: 6, numbersOnly: true, keyboard: .numberPad)
//                        
//                        // Emergency contact in one box
//                        VStack(alignment: .leading, spacing: 6) {
//                            Text("Emergency Contact")
//                                .font(.headline)
//                            
//                            HStack {
//                                prefixBox("+91")
//                                validatedTextField("Number", text: $emergencyNumber, maxLength: 10, numbersOnly: true, keyboard: .numberPad)
//                            }
//                            
//                            Picker("Relation", selection: $emergencyRelation) {
//                                ForEach(relations, id: \.self) { relation in
//                                    Text(relation)
//                                }
//                            }
//                            .pickerStyle(MenuPickerStyle())
//                        }
//                        .padding()
//                        .background(Color(UIColor.secondarySystemBackground))
//                        .cornerRadius(10)
//                        
//                        Picker("Blood Group", selection: $bloodGroup) {
//                            ForEach(bloodGroups, id: \.self) { group in
//                                Text(group)
//                            }
//                        }
//                        .pickerStyle(SegmentedPickerStyle())
//                        
//                        DatePicker("Date of Birth", selection: $dob, displayedComponents: .date)
//                    }
//                    
//                    Button("Save") { editingProfile = false }
//                        .padding(.top, 8)

import SwiftUI
import UIKit
import FirebaseAuth
import FirebaseFirestore

// MARK: - ProfileView (all-in-one)
struct ProfileView: View {
    private let cloudName = "djoaxuvqs"          // <- your Cloudinary cloud name
    private let uploadPreset = "LifeFlow"        // <- must be UNSIGNED

    // Fields
    @State private var name: String = ""
    @State private var phone: String = ""
    @State private var email: String = ""
    @State private var dob: Date = Date()
    @State private var age: Int = 0

    // UI state
    @State private var isEditing: Bool = false
    @State private var message: String = ""
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var isUploading = false
    @State private var uploadedImageURL: String?

    private let db = Firestore.firestore()

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.green.opacity(0.3), Color.teal.opacity(0.4)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    
                    // 🌿 Profile Image
                    Group {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                        } else if let urlString = uploadedImageURL, let url = URL(string: urlString) {
                            AsyncImage(url: url) { image in
                                image.resizable().scaledToFill()
                            } placeholder: { ProgressView() }
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color.white.opacity(0.5))
                                .frame(width: 120, height: 120)
                                .overlay(
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.green)
                                )
                        }
                    }
                    .shadow(radius: 8)
                    .padding(.top, 40)

                    if isEditing {
                        Button(action: { showingImagePicker = true }) {
                            Text("Upload / Change Photo")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                        }
                        .padding(.horizontal)
                    }

                    if isUploading {
                        ProgressView("Uploading...")
                            .padding(.horizontal)
                    }

                    // 🌿 Info Card
                    VStack(spacing: 16) {
                        ProfileRow(title: "Name", text: $name, isEditing: isEditing, icon: "person.fill")
                        ProfileRow(title: "Email", text: $email, isEditing: false, icon: "envelope.fill")
                        ProfileRow(title: "Phone", text: $phone, isEditing: isEditing, icon: "phone.fill")

                        // DOB
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.green)
                                .frame(width: 30)
                            if isEditing {
                                DatePicker("DOB", selection: $dob, displayedComponents: .date)
                                    .onChange(of: dob) { _ in calculateAge() }
                            } else {
                                VStack(alignment: .leading) {
                                    Text("Date of Birth")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("\(dob.formatted(date: .abbreviated, time: .omitted))")
                                        .font(.body)
                                        .foregroundColor(.black)
                                }
                            }
                        }

                        // Age
                        HStack {
                            Image(systemName: "number.circle.fill")
                                .foregroundColor(.green)
                                .frame(width: 30)
                            VStack(alignment: .leading) {
                                Text("Age")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("\(age)")
                                    .font(.body)
                                    .foregroundColor(.black)
                            }
                        }

                        if isEditing {
                            Button(action: saveProfile) {
                                Text("Save Changes")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.green)
                                    .cornerRadius(12)
                                    .shadow(radius: 5)
                            }
                        }
                    }
                    .padding()
                    .background(.white.opacity(0.85))
                    .cornerRadius(20)
                    .shadow(radius: 8)
                    .padding(.horizontal)

                    Button(action: { isEditing.toggle() }) {
                        Text(isEditing ? "Cancel" : "Edit Profile")
                            .font(.headline)
                            .foregroundColor(.green)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal)

                    if !message.isEmpty {
                        Text(message)
                            .foregroundColor(.green)
                            .font(.subheadline)
                            .padding(.top, 10)
                    }
                }
            }
        }
        .onAppear(perform: loadProfile)
        .navigationTitle("My Profile 🌱")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingImagePicker) {
            ProfileImagePicker(image: $selectedImage) { image in
                uploadImageToCloudinary(image)
            }
        }
    }

    // MARK: - Age
    private func calculateAge() {
        let cal = Calendar.current
        age = cal.dateComponents([.year], from: dob, to: Date()).year ?? 0
    }

    // MARK: - Load
    private func loadProfile() {
        guard let user = Auth.auth().currentUser else { return }
        email = user.email ?? ""
        uploadedImageURL = user.photoURL?.absoluteString

        db.collection("users").document(user.uid).getDocument { doc, _ in
            if let doc = doc, doc.exists {
                self.name = (doc["name"] as? String) ?? (user.displayName ?? "")
                self.phone = doc["phone"] as? String ?? ""
                if let ts = doc["dob"] as? Timestamp {
                    self.dob = ts.dateValue()
                }
                self.calculateAge()
                if let savedURL = doc["photoURL"] as? String, (self.uploadedImageURL ?? "").isEmpty {
                    self.uploadedImageURL = savedURL
                }
            } else {
                self.name = user.displayName ?? ""
                self.calculateAge()
            }
        }
    }

    // MARK: - Save
    private func saveProfile() {
        guard let user = Auth.auth().currentUser else { return }
        calculateAge()

        let change = user.createProfileChangeRequest()
        change.displayName = name
        if let urlStr = uploadedImageURL { change.photoURL = URL(string: urlStr) }
        change.commitChanges { _ in }

        db.collection("users").document(user.uid).setData([
            "name": name,
            "phone": phone,
            "email": email,
            "photoURL": uploadedImageURL ?? "",
            "dob": Timestamp(date: dob),
            "age": age
        ], merge: true) { err in
            if let err = err {
                self.message = "❌ \(err.localizedDescription)"
            } else {
                self.message = "✅ Profile updated!"
                self.isEditing = false
            }
        }
    }

    // MARK: - Upload to Cloudinary
    private func uploadImageToCloudinary(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.85) else { return }
        isUploading = true

        CloudinaryUploader.uploadJPEG(
            data: data,
            cloudName: cloudName,
            uploadPreset: uploadPreset
        ) { result in
            DispatchQueue.main.async {
                self.isUploading = false
                switch result {
                case .success(let secureURL):
                    self.uploadedImageURL = secureURL
                    if let user = Auth.auth().currentUser {
                        let change = user.createProfileChangeRequest()
                        change.photoURL = URL(string: secureURL)
                        change.commitChanges { _ in }
                    }
                case .failure(let error):
                    self.message = "❌ Upload failed: \(error.localizedDescription)"
                }
            }
        }
    }
}

// MARK: - ProfileRow
struct ProfileRow: View {
    var title: String
    @Binding var text: String
    var isEditing: Bool
    var icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.green)
                .frame(width: 30)
            if isEditing {
                TextField(title, text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(text.isEmpty ? "Not set" : text)
                        .font(.body)
                        .foregroundColor(.black)
                }
            }
        }
    }
}

// MARK: - ProfileImagePicker (renamed to avoid conflict)
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
            self.parent = parent
            self.onPicked = onPicked
        }
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let img = (info[.editedImage] ?? info[.originalImage]) as? UIImage
            if let img = img {
                parent.image = img
                onPicked(img)
            }
            picker.dismiss(animated: true)
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

// MARK: - CloudinaryUploader
enum CloudinaryUploadError: Error, LocalizedError {
    case badResponse
    case server(String)
    var errorDescription: String? {
        switch self {
        case .badResponse: return "Bad response from server."
        case .server(let msg): return msg
        }
    }
}

struct CloudinaryUploader {
    static func uploadJPEG(data: Data,
                           cloudName: String,
                           uploadPreset: String,
                           completion: @escaping (Result<String, Error>) -> Void) {

        guard let url = URL(string: "https://api.cloudinary.com/v1_1/\(cloudName)/image/upload") else {
            completion(.failure(CloudinaryUploadError.badResponse)); return
        }

        let boundary = "Boundary-\(UUID().uuidString)"
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        func appendFormField(name: String, value: String) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        func appendFileField(name: String, filename: String, mimeType: String, fileData: Data) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
            body.append(fileData)
            body.append("\r\n".data(using: .utf8)!)
        }

        appendFormField(name: "upload_preset", value: uploadPreset)
        appendFileField(name: "file", filename: "profile.jpg", mimeType: "image/jpeg", fileData: data)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        req.httpBody = body

        URLSession.shared.dataTask(with: req) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else { completion(.failure(CloudinaryUploadError.badResponse)); return }

            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                if let secure = json["secure_url"] as? String {
                    completion(.success(secure)); return
                }
                if let err = json["error"] as? [String: Any],
                   let msg = err["message"] as? String {
                    completion(.failure(CloudinaryUploadError.server(msg))); return
                }
            }
            completion(.failure(CloudinaryUploadError.badResponse))
        }.resume()
    }
}

import SwiftUI
import Foundation
import UIKit

struct ProfileView: View {
    // MARK: - Persistent storage
    @AppStorage("userName") private var name: String = "Anindya Mukhopadhyay"
    @AppStorage("userEmail") private var email: String = "you@example.com"
    @AppStorage("userPhone") private var phone: String = ""
    @AppStorage("userAddress") private var address: String = ""
    @AppStorage("userPincode") private var pincode: String = ""
    @AppStorage("emergencyContactNumber") private var emergencyNumber: String = ""
    @AppStorage("emergencyContactRelation") private var emergencyRelation: String = "Mother"
    @AppStorage("userBloodGroup") private var bloodGroup: String = "A-"
    @AppStorage("userDOB") private var dob: Date = Date()
    @AppStorage("profileImageData") private var profileImageData: Data?

    // MARK: - View states
    @State private var showingImagePicker = false
    @State private var editingProfile = false
    
    // MARK: - Options
    private let bloodGroups = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
    private let relations = ["Mother", "Father", "Brother", "Sister", "Grandfather", "Grandmother", "GF", "BF", "Husband", "Wife"]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // MARK: Profile Image
                ZStack(alignment: .bottomTrailing) {
                    if let data = profileImageData,
                       let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.red)
                    }
                    
                    Button(action: { showingImagePicker = true }) {
                        Image(systemName: "camera.fill")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.red)
                            .clipShape(Circle())
                    }
                }
                .padding(.top, 16)
                
                if editingProfile {
                    // MARK: Editable fields
                    Group {
                        validatedTextField("Name", text: $name, maxLength: 30)
                        validatedTextField("Email", text: $email, maxLength: 50, keyboard: .emailAddress)
                        
                        HStack {
                            prefixBox("+91")
                            validatedTextField("Phone Number", text: $phone, maxLength: 10, numbersOnly: true, keyboard: .numberPad)
                        }
                        
                        validatedTextField("Address", text: $address, maxLength: 50)
                        validatedTextField("Pincode", text: $pincode, maxLength: 6, numbersOnly: true, keyboard: .numberPad)
                        
                        // Emergency contact in one box
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Emergency Contact")
                                .font(.headline)
                            
                            HStack {
                                prefixBox("+91")
                                validatedTextField("Number", text: $emergencyNumber, maxLength: 10, numbersOnly: true, keyboard: .numberPad)
                            }
                            
                            Picker("Relation", selection: $emergencyRelation) {
                                ForEach(relations, id: \.self) { relation in
                                    Text(relation)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        
                        Picker("Blood Group", selection: $bloodGroup) {
                            ForEach(bloodGroups, id: \.self) { group in
                                Text(group)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        DatePicker("Date of Birth", selection: $dob, displayedComponents: .date)
                    }
                    
                    Button("Save") { editingProfile = false }
                        .padding(.top, 8)
                } else {
                    // MARK: View Mode
                    VStack(spacing: 4) {
                        Text(name)
                            .font(.title)
                        
                        Button("Edit Profile") { editingProfile = true }
                            .padding(.top, 8)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        recordRow(label: "Email", icon: "envelope.fill", value: email)
                        recordRow(label: "Phone", icon: "phone.fill", value: "+91 \(phone)")
                        recordRow(label: "Address", icon: "house.fill", value: address)
                        recordRow(label: "Pincode", icon: "mappin.and.ellipse", value: pincode)
                        recordRow(label: "Blood Group", icon: "drop.fill", value: bloodGroup)
                        recordRow(label: "Date of Birth", icon: "calendar", value: dob.formatted(date: .abbreviated, time: .omitted))
                        recordRow(label: "Age", icon: "person.fill", value: "\(calculateAge(from: dob))")
                        recordRow(label: "Emergency Contact", icon: "phone.badge.plus", value: "+91 \(emergencyNumber)")
                        recordRow(label: "Relation", icon: "person.2.fill", value: emergencyRelation)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker { image in
                if let image = image {
                    profileImageData = image.jpegData(compressionQuality: 0.8)
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func calculateAge(from date: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: date, to: now)
        return ageComponents.year ?? 0
    }
    
    private func validatedTextField(
        _ title: String,
        text: Binding<String>,
        maxLength: Int,
        numbersOnly: Bool = false,
        keyboard: UIKeyboardType = .default
    ) -> some View {
        TextField(title, text: text)
            .keyboardType(keyboard)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .onChange(of: text.wrappedValue) { oldValue, newValue in
                var filtered = numbersOnly ? newValue.filter { $0.isNumber } : newValue
                if filtered.count > maxLength {
                    filtered = String(filtered.prefix(maxLength))
                }
                text.wrappedValue = filtered
            }
    }
    
    private func prefixBox(_ text: String) -> some View {
        Text(text)
            .padding(.horizontal, 6)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(5)
    }
    
    @ViewBuilder
    private func recordRow(label: String, icon: String, value: String, valueColor: Color = .primary) -> some View {
        HStack {
            Label(label, systemImage: icon)
                .foregroundColor(.red)
            Spacer()
            Text(value)
                .foregroundColor(valueColor)
        }
    }
}

import SwiftUI
import Photos

struct MyCertificateView: View {
    let userName = "Anindya Mukhopadhyay"
    let donationDate = "12 May 2025"

    var certificateContent: some View {
        VStack(spacing: 16) {
            Text("Blood Donation Certificate")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.red)

            Text("This is to certify that")
            Text(userName)
                .font(.title2)
                .fontWeight(.semibold)

            Text("has donated blood on")
            Text(donationDate)
                .font(.headline)

            Text("\nThank you for saving lives!")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(width: 300, height: 350)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 8)
    }

    var body: some View {
        VStack(spacing: 24) {
            certificateContent

            Button(action: {
                let image = certificateContent.snapshot(size: CGSize(width: 350, height: 400))
                saveImageToPhotos(image: image)
            }) {
                Label("Download", systemImage: "arrow.down.circle")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .navigationTitle("My Certificate")
    }

    func saveImageToPhotos(image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            } else {
                print("Permission not granted to access photo library.")
            }
        }
    }
}

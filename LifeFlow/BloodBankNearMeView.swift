import SwiftUI
import MapKit

struct BloodBankNearMeView: View {
    @ObservedObject private var locationManager = LocationManager()
    @StateObject private var speechRecognizer = SpeechRecognizer()

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 22.5726, longitude: 88.3639),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    @State private var searchText = ""

    let bloodBanks: [BloodBank] = [
        BloodBank(name: "Red Cross Center", address: "123 Park St", latitude: 22.5726, longitude: 88.3639),
        BloodBank(name: "LifeBank", address: "456 City Rd", latitude: 22.58, longitude: 88.38),
        BloodBank(name: "HealthPlus Blood Bank", address: "789 Health Ave", latitude: 22.55, longitude: 88.35)
    ]

    var filteredBanks: [BloodBank] {
        if searchText.isEmpty {
            return bloodBanks
        } else {
            return bloodBanks.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 12) {

                // Search Bar + 🎤
                HStack {
                    TextField("Search blood banks...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        speechRecognizer.isListening ? speechRecognizer.stopTranscribing() : speechRecognizer.startTranscribing()
                    }) {
                        Image(systemName: speechRecognizer.isListening ? "mic.fill" : "mic")
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal)

                // Map
                Map(coordinateRegion: $region)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding(.horizontal)

                // Blood Bank List with distance & directions
                List(filteredBanks) { bank in
                    VStack(alignment: .leading) {
                        Text(bank.name)
                            .font(.headline)
                        Text(bank.address)
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        if let userLocation = locationManager.location {
                            let distance = calculateDistance(from: userLocation.coordinate, to: CLLocationCoordinate2D(latitude: bank.latitude, longitude: bank.longitude))
                            Text("Distance: \(String(format: "%.2f", distance)) km")
                                .font(.caption)
                                .foregroundColor(.blue)

                            Button("📍 Directions") {
                                openInMaps(destination: bank)
                            }
                            .font(.caption)
                            .foregroundColor(.red)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Blood Banks Near Me")
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("SpeechText")), perform: { notification in
                if let text = notification.object as? String {
                    searchText = text
                }
            })
        }
    }

    func calculateDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let fromLoc = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLoc = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLoc.distance(from: toLoc) / 1000  // in kilometers
    }

    func openInMaps(destination: BloodBank) {
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude))
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = destination.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

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
            // Kolkata and surrounding areas
            BloodBank(name: "Institute of Blood Transfusion Medicine & Immuno Haematology (Central Blood Centre)", address: "Manicktala, Kolkata", latitude: 22.585, longitude: 88.39),
            BloodBank(name: "S.S.K.M. Hospital (IPGME&R) Blood Centre", address: "Kolkata, West Bengal", latitude: 22.545, longitude: 88.345),
            BloodBank(name: "Calcutta Medical College & Hospital Blood Centre", address: "Kolkata, West Bengal", latitude: 22.573, longitude: 88.362),
            BloodBank(name: "R.G. Kar Medical College & Hospital Blood Centre", address: "Kolkata, West Bengal", latitude: 22.602, longitude: 88.385),
            BloodBank(name: "Calcutta National Medical College Hospital Blood Bank", address: "Kolkata, West Bengal", latitude: 22.55, longitude: 88.37),
            BloodBank(name: "ESI Hospital Maniktala Blood Centre", address: "Maniktala, Kolkata", latitude: 22.585, longitude: 88.39),
            BloodBank(name: "Chittaranjan National Cancer Institute Blood Bank", address: "Kolkata, West Bengal", latitude: 22.53, longitude: 88.35),
            BloodBank(name: "B. M. Birla Heart Research Centre Blood Bank", address: "Kolkata, West Bengal", latitude: 22.527, longitude: 88.337),
            BloodBank(name: "Apollo Gleneagles Hospital Blood Bank", address: "Kolkata, West Bengal", latitude: 22.585, longitude: 88.398),
            BloodBank(name: "Belle Vue Clinic / Belle Vue Nursing Home Blood Bank", address: "Kolkata, West Bengal", latitude: 22.548, longitude: 88.349),
            BloodBank(name: "Ramakrishna Mission Seva Pratishthan Blood Bank", address: "Sarat Bose Road, Kolkata", latitude: 22.527, longitude: 88.35),
            BloodBank(name: "Medica Super Specialty Hospital Blood Bank", address: "Mukundapur, Kolkata", latitude: 22.518, longitude: 88.399),
            BloodBank(name: "Bhoruka Public Welfare Trust / Blood Bank", address: "Park Street, Kolkata", latitude: 22.557, longitude: 88.358),
            BloodBank(name: "Life Care Medical Complex Blood Bank (People's Blood Bank)", address: "Entally, Kolkata", latitude: 22.544, longitude: 88.341),
            BloodBank(name: "College of Medicine & Sagore Dutta Hospital Blood Bank", address: "Kamarhati, Kolkata", latitude: 22.675, longitude: 88.374),
            BloodBank(name: "Howrah District Hospital Blood Centre", address: "Howrah, West Bengal", latitude: 22.576, longitude: 88.324),
            BloodBank(name: "Uluberia Sub-Divisional Hospital Blood Centre", address: "Uluberia, Howrah", latitude: 22.585, longitude: 88.081),
            BloodBank(name: "Imambara Sadar Hospital Blood Bank", address: "Chinsurah, Hooghly", latitude: 22.89, longitude: 88.39),
            BloodBank(name: "Walsh / Serampore Hospital Blood Bank", address: "Serampore, Hooghly", latitude: 22.755, longitude: 88.349),
            // Bardhaman Division
            BloodBank(name: "Burdwan Medical College & Hospital Blood Bank", address: "Bardhaman, West Bengal", latitude: 23.24, longitude: 87.86),
            BloodBank(name: "Asansol District Hospital Blood Bank", address: "Asansol, West Bengal", latitude: 23.68, longitude: 86.99),
            BloodBank(name: "Burnpur Hospital (SAIL-ISP) Blood Bank", address: "Asansol/Burnpur, West Bengal", latitude: 23.659, longitude: 86.924),
            BloodBank(name: "Durgapur Steel Plant Hospital Blood Bank", address: "Durgapur, Paschim Bardhaman", latitude: 23.518, longitude: 87.319),
            BloodBank(name: "The Mission Hospital Blood Bank", address: "Durgapur, Paschim Bardhaman", latitude: 23.499, longitude: 87.337),
            BloodBank(name: "Vivekananda Hospital Pvt. Ltd. Blood Bank", address: "Durgapur, Paschim Bardhaman", latitude: 23.498, longitude: 87.309),
            BloodBank(name: "IQ City Narayana Multispeciality Hospital Blood Bank", address: "Durgapur, Paschim Bardhaman", latitude: 23.58, longitude: 87.3),
            BloodBank(name: "Kalna Sub-Divisional Hospital Blood Bank", address: "Kalna, Purba Bardhaman", latitude: 23.21, longitude: 88.36),
            BloodBank(name: "Suri (Birbhum) District Hospital Blood Bank", address: "Suri, Birbhum", latitude: 23.905, longitude: 87.533),
            BloodBank(name: "Sanctoria / Dishergarh Hospitals Blood Bank", address: "Dishergarh, Paschim Bardhaman", latitude: 23.705, longitude: 86.852),
            // Medinipur Division
            BloodBank(name: "Kharagpur Sub-Divisional Hospital Blood Bank", address: "Kharagpur, Paschim Medinipur", latitude: 22.338, longitude: 87.332),
            BloodBank(name: "Haldia Hospital Blood Bank", address: "Haldia, Purba Medinipur", latitude: 22.057, longitude: 88.082),
            BloodBank(name: "Purulia District Hospital Blood Bank", address: "Purulia, West Bengal", latitude: 23.328, longitude: 86.377),
            BloodBank(name: "Bankura Sammilani Medical College & Hospital Blood Centre", address: "Bankura, West Bengal", latitude: 23.23, longitude: 87.06),
            // Presidency Division
            BloodBank(name: "Nabadwip State General Hospital Blood Bank", address: "Nabadwip, Nadia", latitude: 23.402, longitude: 88.384),
            BloodBank(name: "Kalyani General Hospital / GM Hospital Blood Bank", address: "Kalyani, Nadia", latitude: 22.973, longitude: 88.435),
            // Jalpaiguri Division (North Bengal)
            BloodBank(name: "Jalpaiguri District Hospital Blood Bank", address: "Jalpaiguri, West Bengal", latitude: 26.529, longitude: 88.718),
            BloodBank(name: "North Bengal Medical College Blood Bank", address: "Siliguri / Darjeeling area", latitude: 26.757, longitude: 88.423),
            BloodBank(name: "Raiganj District Hospital Blood Bank", address: "Raiganj, Uttar Dinajpur", latitude: 25.617, longitude: 88.114),
            BloodBank(name: "Malda District Hospital Blood Bank", address: "Malda, West Bengal", latitude: 25.0, longitude: 88.14),
            BloodBank(name: "Murshidabad Medical College & Hospital Blood Centre", address: "Murshidabad, West Bengal", latitude: 24.11, longitude: 88.26),
            BloodBank(name: "Coochbehar District Hospital (MJN) Blood Centre", address: "Coochbehar, West Bengal", latitude: 26.33, longitude: 89.45),
            BloodBank(name: "Alipurduar District Hospital Blood Centre", address: "Alipurduar, West Bengal", latitude: 26.5, longitude: 89.52),
            // Other notable blood banks
            BloodBank(name: "Ashok Laboratory (Centre for Transfusion Medicine)", address: "Jodhpur Park, Kolkata", latitude: 22.505, longitude: 88.361),
            BloodBank(name: "Life Line Blood Bank (Raniganj)", address: "Raniganj, Paschim Bardhaman", latitude: 23.615, longitude: 87.121),
            BloodBank(name: "Tamluk District Hospital Blood Bank", address: "Tamluk, Purba Medinipur", latitude: 22.3, longitude: 87.92),
            BloodBank(name: "Contai S.D. Hospital Blood Bank", address: "Contai, Purba Medinipur", latitude: 21.78, longitude: 87.75),
            BloodBank(name: "Baruipur Sub-Divisional Hospital Blood Bank", address: "Baruipur, South 24 Parganas", latitude: 22.36, longitude: 88.43),
            BloodBank(name: "Diamond Harbour S.D. Hospital Blood Bank", address: "Diamond Harbour, South 24 Parganas", latitude: 22.18, longitude: 88.18),
            BloodBank(name: "M.R. Bangur District Hospital Blood Bank", address: "Tollygunge, Kolkata", latitude: 22.49, longitude: 88.34),
            BloodBank(name: "Bishnupur Sub-Divisional Hospital Blood Bank", address: "Bishnupur, Bankura", latitude: 23.07, longitude: 87.32),
            BloodBank(name: "Jhargram District Hospital Blood Bank", address: "Jhargram, West Bengal", latitude: 22.45, longitude: 86.99),
            BloodBank(name: "Chandannagar S.D. Hospital Blood Bank", address: "Chandannagar, Hooghly", latitude: 22.86, longitude: 88.37),
            BloodBank(name: "Barasat District Hospital Blood Bank", address: "Barasat, North 24 Parganas", latitude: 22.70, longitude: 88.47),
            BloodBank(name: "Barrackpore S.D. Hospital (B.N. Bose Hospital) Blood Bank", address: "Barrackpore, North 24 Parganas", latitude: 22.78, longitude: 88.37),
            BloodBank(name: "Bongaon S.D. Hospital (Dr. J.R. Dhar) Blood Bank", address: "Bongaon, North 24 Parganas", latitude: 23.07, longitude: 88.82),
            BloodBank(name: "Krishnanagar District Hospital (Shaktinagar) Blood Bank", address: "Krishnanagar, Nadia", latitude: 23.41, longitude: 88.50),
            BloodBank(name: "Ranaghat S.D. Hospital Blood Bank", address: "Ranaghat, Nadia", latitude: 23.18, longitude: 88.57),
            BloodBank(name: "Katwa S.D. Hospital (Hemraj) Blood Bank", address: "Katwa, Purba Bardhaman", latitude: 23.63, longitude: 88.12),
            BloodBank(name: "Rampurhat Government Medical College & Hospital Blood Bank", address: "Rampurhat, Birbhum", latitude: 24.16, longitude: 87.77),
            BloodBank(name: "Jangipur Sub-Divisional Hospital Blood Bank", address: "Jangipur, Murshidabad", latitude: 24.47, longitude: 88.07),
            BloodBank(name: "Kandi Sub-Divisional Hospital Blood Bank", address: "Kandi, Murshidabad", latitude: 23.95, longitude: 88.05),
            BloodBank(name: "Balurghat District Hospital Blood Bank", address: "Balurghat, Dakshin Dinajpur", latitude: 25.22, longitude: 88.76),
            BloodBank(name: "Islampur S.D. Hospital Blood Bank", address: "Islampur, Uttar Dinajpur", latitude: 26.26, longitude: 88.16),
            BloodBank(name: "Siliguri Sub-Divisional Hospital Blood Bank", address: "Siliguri, Darjeeling", latitude: 26.71, longitude: 88.42),
            BloodBank(name: "NRS Medical College Blood Bank", address: "Sealdah, Kolkata", latitude: 22.55, longitude: 88.37),
            BloodBank(name: "Woodlands Multispeciality Hospital Blood Bank", address: "Alipore, Kolkata", latitude: 22.52, longitude: 88.32),
            BloodBank(name: "Techno Global Hospital Blood Bank", address: "Barrackpore, North 24 Parganas", latitude: 22.62, longitude: 88.42),
            BloodBank(name: "Lions Blood Centre", address: "Barisha, Kolkata", latitude: 22.49, longitude: 88.31),
            BloodBank(name: "AMRI Hospital Blood Bank", address: "Dhakuria, Kolkata", latitude: 22.51, longitude: 88.36),
            BloodBank(name: "Basirhat District Hospital Blood Bank", address: "Basirhat, North 24 Parganas", latitude: 22.65, longitude: 88.88),
            BloodBank(name: "Gangarampur Sub-Divisional Hospital Blood Bank", address: "Gangarampur, Dakshin Dinajpur", latitude: 25.40, longitude: 88.51),
            BloodBank(name: "Ghatal Sub-Divisional Hospital Blood Bank", address: "Ghatal, Paschim Medinipur", latitude: 22.67, longitude: 87.71),
            BloodBank(name: "Midnapore Medical College and Hospital Blood Bank", address: "Midnapore, Paschim Medinipur", latitude: 22.42, longitude: 87.32),
            BloodBank(name: "Egra Sub-Divisional Hospital Blood Bank", address: "Egra, Purba Medinipur", latitude: 21.89, longitude: 87.52),
            BloodBank(name: "Domkal Sub-Divisional Hospital Blood Bank", address: "Domkal, Murshidabad", latitude: 24.16, longitude: 88.62),
            BloodBank(name: "Lalbagh Sub-Divisional Hospital Blood Bank", address: "Lalbagh, Murshidabad", latitude: 24.19, longitude: 88.25),
            BloodBank(name: "Diamond Harbour Medical College and Hospital Blood Bank", address: "Diamond Harbour, South 24 Parganas", latitude: 22.18, longitude: 88.18),
            BloodBank(name: "Kalyani Medical College and Hospital Blood Bank", address: "Kalyani, Nadia", latitude: 22.97, longitude: 88.43),
            BloodBank(name: "Birpara State General Hospital Blood Bank", address: "Birpara, Alipurduar", latitude: 26.69, longitude: 89.15),
            BloodBank(name: "Falakata Sub-Divisional Hospital Blood Bank", address: "Falakata, Alipurduar", latitude: 26.54, longitude: 89.20),
            BloodBank(name: "Dinhata Sub-Divisional Hospital Blood Bank", address: "Dinhata, Coochbehar", latitude: 26.13, longitude: 89.47),
            BloodBank(name: "Mathabhanga Sub-Divisional Hospital Blood Bank", address: "Mathabhanga, Coochbehar", latitude: 26.35, longitude: 89.23),
            BloodBank(name: "Kanchrapara Railway Hospital Blood Bank", address: "Kanchrapara, North 24 Parganas", latitude: 22.95, longitude: 88.43),
            BloodBank(name: "BR Singh Railway Hospital Blood Bank", address: "Sealdah, Kolkata", latitude: 22.56, longitude: 88.37),
            BloodBank(name: "Adra Railway Hospital Blood Bank", address: "Adra, Purulia", latitude: 23.43, longitude: 86.67),
            BloodBank(name: "Dooars Hospital Blood Bank", address: "Malbazar, Jalpaiguri", latitude: 26.89, longitude: 88.75),
            BloodBank(name: "Jadavpur University Blood Bank", address: "Jadavpur, Kolkata", latitude: 22.50, longitude: 88.37),
            BloodBank(name: "Sagar Datta Hospital Blood Bank", address: "Kamarhati, North 24 Parganas", latitude: 22.67, longitude: 88.37),
            BloodBank(name: "Marwari Relief Society Hospital Blood Bank", address: "Burrabazar, Kolkata", latitude: 22.57, longitude: 88.35),
            BloodBank(name: "Thakurpukur Cancer Centre Blood Bank", address: "Thakurpukur, Kolkata", latitude: 22.47, longitude: 88.31),
            BloodBank(name: "Vivekananda Institute of Medical Sciences Blood Bank", address: "Dhakuria, Kolkata", latitude: 22.51, longitude: 88.37),
            BloodBank(name: "Lions Club of Calcutta Blood Bank", address: "Entally, Kolkata", latitude: 22.55, longitude: 88.37),
            BloodBank(name: "Rotary Blood Bank", address: "Ballygunge, Kolkata", latitude: 22.51, longitude: 88.36),
            BloodBank(name: "Indian Association of Blood Cancer & Allied Diseases", address: "Kankurgachi, Kolkata", latitude: 22.58, longitude: 88.38),
            // NEW ADDITIONS
            BloodBank(name: "Darjeeling District Hospital Blood Bank", address: "Darjeeling, West Bengal", latitude: 27.04, longitude: 88.26),
            BloodBank(name: "Sagar Datta Hospital Blood Centre", address: "Kamarhati, Kolkata", latitude: 22.67, longitude: 88.37),
            BloodBank(name: "Nabadwip Sub-Divisional Hospital Blood Bank", address: "Nabadwip, Nadia", latitude: 23.40, longitude: 88.38),
            BloodBank(name: "Bishnupur Sub-Divisional Hospital Blood Bank", address: "Bishnupur, South 24 Parganas", latitude: 22.31, longitude: 88.35),
            BloodBank(name: "Arambagh Sub-Divisional Hospital Blood Bank", address: "Arambagh, Hooghly", latitude: 22.88, longitude: 87.78),
            BloodBank(name: "Chuchura Imambara Sadar Hospital Blood Bank", address: "Chuchura, Hooghly", latitude: 22.89, longitude: 88.39),
            BloodBank(name: "Narayangarh BPHC Blood Bank", address: "Narayangarh, Paschim Medinipur", latitude: 22.06, longitude: 87.35),
            BloodBank(name: "Belpahari BPHC Blood Bank", address: "Belpahari, Jhargram", latitude: 22.61, longitude: 86.68),
            BloodBank(name: "Purulia Medical College & Hospital Blood Bank", address: "Purulia, West Bengal", latitude: 23.32, longitude: 86.37),
            BloodBank(name: "Salt Lake Sub-Divisional Hospital Blood Bank", address: "Salt Lake, Kolkata", latitude: 22.57, longitude: 88.42),
            BloodBank(name: "Kalna Super Speciality Hospital Blood Bank", address: "Kalna, Purba Bardhaman", latitude: 23.21, longitude: 88.36),
            BloodBank(name: "Jhalda Rural Hospital Blood Bank", address: "Jhalda, Purulia", latitude: 23.23, longitude: 85.96),
            BloodBank(name: "Gazole Rural Hospital Blood Bank", address: "Gazole, Malda", latitude: 25.13, longitude: 88.08),
            BloodBank(name: "Tufanganj Sub-Divisional Hospital Blood Bank", address: "Tufanganj, Coochbehar", latitude: 26.21, longitude: 89.65),
            BloodBank(name: "Patrasayer Rural Hospital Blood Bank", address: "Patrasayer, Bankura", latitude: 23.10, longitude: 87.65),
            BloodBank(name: "Gobra Sub-Divisional Hospital Blood Bank", address: "Gobra, North 24 Parganas", latitude: 22.59, longitude: 88.46),
            BloodBank(name: "Sodepur State General Hospital Blood Bank", address: "Sodepur, North 24 Parganas", latitude: 22.73, longitude: 88.37),
            BloodBank(name: "Bagnan Sub-Divisional Hospital Blood Bank", address: "Bagnan, Howrah", latitude: 22.46, longitude: 87.97),
            BloodBank(name: "Bhatpara State General Hospital Blood Bank", address: "Bhatpara, North 24 Parganas", latitude: 22.87, longitude: 88.41),
            BloodBank(name: "Ranaghat Sub-Divisional Hospital Blood Bank", address: "Ranaghat, Nadia", latitude: 23.18, longitude: 88.57),
            BloodBank(name: "Raghunathpur Sub-Divisional Hospital Blood Bank", address: "Raghunathpur, Purulia", latitude: 23.55, longitude: 86.64)
        ]

    var filteredBanks: [BloodBank] {
        guard let userLocation = locationManager.location else {
            // If user location not yet available, just return by search filter
            return searchText.isEmpty ? bloodBanks : bloodBanks.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }

        // Filter first, then sort by distance
        let filtered = searchText.isEmpty ? bloodBanks : bloodBanks.filter {
            $0.name.lowercased().contains(searchText.lowercased())
        }

        return filtered.sorted {
            let dist1 = calculateDistance(from: userLocation.coordinate,
                                          to: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude))
            let dist2 = calculateDistance(from: userLocation.coordinate,
                                          to: CLLocationCoordinate2D(latitude: $1.latitude, longitude: $1.longitude))
            return dist1 < dist2
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

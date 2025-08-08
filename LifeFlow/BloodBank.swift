import Foundation
import CoreLocation

struct BloodBank: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
}

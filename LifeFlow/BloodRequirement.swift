import Foundation

struct BloodRequirement: Identifiable {
    let id = UUID()
    let hospital: String
    let bloodGroup: String
    let unitsNeeded: Int
    let urgency: String
}

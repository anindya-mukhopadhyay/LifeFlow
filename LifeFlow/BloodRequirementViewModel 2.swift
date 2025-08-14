import FirebaseFirestore
import FirebaseFirestoreSwift

class BloodRequirementViewModel: ObservableObject {
    @Published var requirements: [BloodRequirement] = []
    private var db = Firestore.firestore()
    
    func listenToRequirements() {
        db.collection("bloodRequirements")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching: \(error)")
                    return
                }
                self.requirements = snapshot?.documents.compactMap {
                    try? $0.data(as: BloodRequirement.self)
                } ?? []
            }
    }
}

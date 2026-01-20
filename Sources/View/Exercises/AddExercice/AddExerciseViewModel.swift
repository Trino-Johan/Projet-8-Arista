import Foundation
import CoreData

final class AddExerciseViewModel: ObservableObject {
    @Published var category: String = ""
    @Published var startTime: Date = Date()
    @Published var duration: Int = 0
    @Published var intensity: Int = 0
    
    private let exerciseRepository: ExerciseRepository

        init(exerciseRepository: ExerciseRepository = ExerciseRepository()) {
            self.exerciseRepository = exerciseRepository
        }
    
    func addExercise() {
        do {
            try exerciseRepository.addExercise(
                category: category,
                duration: duration,
                intensity: intensity,
                startDate: startTime
            )
            
        } catch {
            print("Error when trying to add exercise: \(error)")
        }
    }
}

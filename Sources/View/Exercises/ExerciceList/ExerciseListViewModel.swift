import Foundation

class ExerciseListViewModel: ObservableObject {
    @Published var exercises = [Exercise]()
    
    let repository: ExerciseRepository

    init(repository: ExerciseRepository = ExerciseRepository()) {
        self.repository = repository
        fetchExercises()
    }

    
    private func fetchExercises() {
        
        do {
            exercises = try repository.getExercises()
        } catch {
            print("Error when trying to get exercises: \(error)")
        }
    }
    
    func reload() {
        fetchExercises()
    }
}

import Foundation
import CoreData

class ExerciseListViewModel: ObservableObject {
    @Published var exercises = [Exercise]()
    
    private var viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchExercises()
    }
    
    private func fetchExercises() {
        let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Exercise.startDate, ascending: false)]
        
        do {
            exercises = try viewContext.fetch(fetchRequest)
        } catch {
            print("Error when trying to get exercises: \(error)")
        }
    }
    
    func reload() {
        fetchExercises()
    }
}

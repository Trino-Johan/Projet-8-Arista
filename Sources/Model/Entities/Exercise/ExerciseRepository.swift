import CoreData
import Foundation

struct ExerciseRepository {
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    func getExercises() throws -> [Exercise] {
        let request = Exercise.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Exercise.startDate, ascending: false)]
        
        return try viewContext.fetch(request)
    }
    
    func addExercise(category: String, duration: Int, intensity: Int, startDate: Date) throws {
        let exercise = Exercise(context: viewContext)
        exercise.category = category
        exercise.duration = Int64(duration)
        exercise.intensity = Int64(intensity)
        exercise.startDate = startDate
        
        // Debug, user trouvé ?
        if let user = try? UserRepository(viewContext: viewContext).getUser() {
            print("Utilisateur trouvé: \(user.firstName ?? "?")")
            exercise.user = user
        } else {
            print("ERREUR : Aucun utilisateur trouvé !")
            throw NSError(domain: "ExerciseRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "Aucun utilisateur trouvé"])
        }
        
        try viewContext.save()
    }
}

//les vues ne parlent jamais directement à Core Data, tout passe par ces repositories
// throw pour les erreurs, mais elles seront gérées dans le VM

//Apple indique qu’il est préférable de faire cela dans un contexte de fond, car l’usage de gros volumes de données peut être intensif pour le processeur et bloquer l’UI.
//Toutefois, dans le cadre d’un usage limité ET strictement lié à l’action d’un utilisateur, cela est acceptable. Notez bien la dualité des deux conditions.

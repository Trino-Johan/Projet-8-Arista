import XCTest
import CoreData
@testable import Arista

final class ExerciseRepositoryTests: XCTestCase {
    
    // MARK: - Helper Methods
    
    private func emptyEntities(context: NSManagedObjectContext) {
        let fetchRequest = Exercise.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        
        for exercise in objects {
            context.delete(exercise)
        }
        
        try! context.save()
    }
    
    private func addExercise(context: NSManagedObjectContext, category: String, duration: Int, intensity: Int, startDate: Date, userFirstName: String, userLastName: String) {
        let newUser = User(context: context)
        newUser.firstName = userFirstName
        newUser.lastName = userLastName
        try! context.save()
        
        let newExercise = Exercise(context: context)
        newExercise.category = category
        newExercise.duration = Int64(duration)
        newExercise.intensity = Int64(intensity)
        newExercise.startDate = startDate
        newExercise.user = newUser
        try! context.save()
    }
    
    // MARK: - Tests getExercise()
    
    func test_WhenNoExerciseIsInDatabase_GetExercise_ReturnEmptyList() {
        // Clean manually all data
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let data = ExerciseRepository(viewContext: persistenceController.container.viewContext)
        let exercises = try! data.getExercise()
        
        XCTAssert(exercises.isEmpty == true)
    }
    
    func test_WhenAddingOneExerciseInDatabase_GetExercise_ReturnAListContainingTheExercise() {
        // Clean manually all data
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        let date = Date()
        
        addExercise(context: persistenceController.container.viewContext,
                   category: "Football",
                   duration: 10,
                   intensity: 5,
                   startDate: date,
                   userFirstName: "Eric",
                   userLastName: "Marcus")
        
        let data = ExerciseRepository(viewContext: persistenceController.container.viewContext)
        let exercises = try! data.getExercise()
        
        XCTAssert(exercises.isEmpty == false)
        XCTAssert(exercises.first?.category == "Football")
        XCTAssert(exercises.first?.duration == 10)
        XCTAssert(exercises.first?.intensity == 5)
        XCTAssert(exercises.first?.startDate == date)
    }
    
    func test_WhenAddingMultipleExerciseInDatabase_GetExercise_ReturnAListContainingTheExerciseInTheRightOrder() {
        // Clean manually all data
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60*60*24))
        let date3 = Date(timeIntervalSinceNow: -(60*60*24*2))
        
        addExercise(context: persistenceController.container.viewContext,
                   category: "Football",
                   duration: 10,
                   intensity: 5,
                   startDate: date1,
                   userFirstName: "Erica",
                   userLastName: "Marcusi")
        
        addExercise(context: persistenceController.container.viewContext,
                   category: "Running",
                   duration: 120,
                   intensity: 1,
                   startDate: date3,
                   userFirstName: "Erice",
                   userLastName: "Marceau")
        
        addExercise(context: persistenceController.container.viewContext,
                   category: "Fitness",
                   duration: 30,
                   intensity: 5,
                   startDate: date2,
                   userFirstName: "Frédericd",
                   userLastName: "Marcus")
        
        let data = ExerciseRepository(viewContext: persistenceController.container.viewContext)
        let exercises = try! data.getExercise()
        
        XCTAssert(exercises.count == 3)
        XCTAssert(exercises[0].category == "Football")
        XCTAssert(exercises[1].category == "Fitness")
        XCTAssert(exercises[2].category == "Running")
    }
    
    // MARK: - Tests addExercise()

    func test_WhenAddingValidExercise_AddExercise_SavesItToDatabase() {
        
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let repository = ExerciseRepository(viewContext: persistenceController.container.viewContext)
        
        
        try! repository.addExercise(
            category: "Running",
            duration: 30,
            intensity: 7,
            startDate: Date()

        )
        
      
        let exercises = try! repository.getExercise()
        XCTAssert(exercises.count == 1)
        XCTAssert(exercises.first?.category == "Running")
        XCTAssert(exercises.first?.duration == 30)
        XCTAssert(exercises.first?.intensity == 7)
    }

    func test_WhenAddingMultipleExercises_AddExercise_SavesThemAll() {
     
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let repository = ExerciseRepository(viewContext: persistenceController.container.viewContext)
        
       
        try! repository.addExercise(category: "Running", duration: 30, intensity: 7, startDate: Date())
        try! repository.addExercise(category: "Football", duration: 60, intensity: 5, startDate: Date())
       
        let exercises = try! repository.getExercise()
        XCTAssert(exercises.count == 2)
    }

}

//Cours: Dans chaque test, nous écrivons les conditions de départ, l’objectif et le résultat attendu pour obtenir ce résultat.L'exécution des tests à ce stade présente le risque d'échouer, qui est lié à CoreData. Par défaut, nous créons des éléments dans la base de données si celle-ci ne les contient pas, via le code dans le fichier  DefaultData  . Ce code s’applique quel que soit le type de  persistentStore  utilisé dans le projet (InMemory ou non).D’ailleurs, revenons sur ce point : le fait de mettre le contenant en mémoire et non en physique permet de créer une base de données temporaire. Cela permet donc aux tests de s'exécuter dans une base de données vierge. Il est important d’avoir un comportement prédictif quand on joue (exécute) les tests. Par ailleurs, une fois les tests joués (exécutés), les données créées seront automatiquement supprimées car uniquement en mémoire.

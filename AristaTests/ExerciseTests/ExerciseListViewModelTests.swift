import XCTest
import CoreData
@testable import Arista

final class ExerciseListViewModelTests: XCTestCase {
    
    // MARK: - Tests
    
    func test_WhenNoExerciseIsInDatabase_FetchExercise_ReturnEmptyList() {
        let persistenceController = PersistenceController(inMemory: true)
        let testContext = persistenceController.container.viewContext
        emptyEntities(context: testContext)
        
        let repository = ExerciseRepository(viewContext: testContext)
        let viewModel = ExerciseListViewModel(repository: repository)
        
        XCTAssert(viewModel.exercises.isEmpty)
    }
    
    func test_WhenAddingOneExerciseInDatabase_FetchExercise_ReturnAListContainingTheExercise() {
        let persistenceController = PersistenceController(inMemory: true)
        let testContext = persistenceController.container.viewContext
        emptyEntities(context: testContext)
        let date = Date()
        
        addExercise(context: testContext,
                   category: "Football",
                   duration: 10,
                   intensity: 5,
                   startDate: date,
                   userFirstName: "Eric",
                   userLastName: "Marcus")
        
        let repository = ExerciseRepository(viewContext: testContext)
        let viewModel = ExerciseListViewModel(repository: repository)
        
        XCTAssert(viewModel.exercises.isEmpty == false)
        XCTAssert(viewModel.exercises.first?.category == "Football")
        XCTAssert(viewModel.exercises.first?.duration == 10)
        XCTAssert(viewModel.exercises.first?.intensity == 5)
        XCTAssert(viewModel.exercises.first?.startDate == date)
    }
    
    func test_WhenAddingMultipleExerciseInDatabase_FetchExercise_ReturnAListContainingTheExerciseInTheRightOrder() {
        let persistenceController = PersistenceController(inMemory: true)
        let testContext = persistenceController.container.viewContext
        emptyEntities(context: testContext)
        
        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60*60*24))
        let date3 = Date(timeIntervalSinceNow: -(60*60*24*2))
        
        addExercise(context: testContext,
                   category: "Football",
                   duration: 10,
                   intensity: 5,
                   startDate: date1,
                   userFirstName: "Eric",
                   userLastName: "Marcus")
        
        addExercise(context: testContext,
                   category: "Running",
                   duration: 120,
                   intensity: 1,
                   startDate: date3,
                   userFirstName: "Bob",
                   userLastName: "Marceau")
        
        addExercise(context: testContext,
                   category: "Fitness",
                   duration: 30,
                   intensity: 5,
                   startDate: date2,
                   userFirstName: "Fred",
                   userLastName: "Martin")
        
        let repository = ExerciseRepository(viewContext: testContext)
        let viewModel = ExerciseListViewModel(repository: repository)
        
        XCTAssertEqual(viewModel.exercises.count, 3)
        XCTAssertEqual(viewModel.exercises[0].category, "Football")
        XCTAssertEqual(viewModel.exercises[1].category, "Fitness")
        XCTAssertEqual(viewModel.exercises[2].category, "Running")
    }
    
    func test_WhenReloadIsCalled_FetchExercises_UpdatesList() {
        let persistenceController = PersistenceController(inMemory: true)
        let testContext = persistenceController.container.viewContext
        emptyEntities(context: testContext)
        
        let repository = ExerciseRepository(viewContext: testContext)
        let viewModel = ExerciseListViewModel(repository: repository)
        
        XCTAssert(viewModel.exercises.isEmpty)
        
        // Ajouter un exercice
        let date = Date()
        addExercise(context: testContext,
                   category: "Running",
                   duration: 30,
                   intensity: 5,
                   startDate: date,
                   userFirstName: "Test",
                   userLastName: "User")
        
        // Appeler reload
        viewModel.reload()
        
        XCTAssertEqual(viewModel.exercises.count, 1)
        XCTAssertEqual(viewModel.exercises.first?.category, "Running")
    }
    
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
}

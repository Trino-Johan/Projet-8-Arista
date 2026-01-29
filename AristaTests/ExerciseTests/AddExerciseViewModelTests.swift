import XCTest
import CoreData
@testable import Arista

final class AddExerciseViewModelTests: XCTestCase {
    
    var persistenceController: PersistenceController!
    var viewModel: AddExerciseViewModel!
    
    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        
        // User pour les tests
        let user = User(context: persistenceController.container.viewContext)
        user.firstName = "Test"
        user.lastName = "User"
        try persistenceController.container.viewContext.save()
        
        let repository = ExerciseRepository(viewContext: persistenceController.container.viewContext)
        viewModel = AddExerciseViewModel(exerciseRepository: repository)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        persistenceController = nil
    }
    
    // MARK: - Tests
    
    func test_WhenAddingExercise_ExerciseIsSavedInDatabase() throws {
        // Given
        viewModel.category = "Football"
        viewModel.duration = 60
        viewModel.intensity = 8
        let startDate = Date()
        viewModel.startTime = startDate
        
        // When
        viewModel.addExercise()
        
        // Then
        let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        let exercises = try persistenceController.container.viewContext.fetch(fetchRequest)
        
        XCTAssertEqual(exercises.count, 1)
        XCTAssertEqual(exercises.first?.category, "Football")
        XCTAssertEqual(exercises.first?.duration, 60)
        XCTAssertEqual(exercises.first?.intensity, 8)
        
        // Vérifier la date avec unwrapping
        if let savedDate = exercises.first?.startDate {
            XCTAssertEqual(savedDate.timeIntervalSince1970, startDate.timeIntervalSince1970, accuracy: 1.0)
        } else {
            XCTFail("startDate should not be nil")
        }
    }
}

import SwiftUI

@main
struct AristaApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            TabView {
                UserDataView(viewModel: UserDataViewModel())
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .tabItem {
                        Label("Utilisateur", systemImage: "person")
                    }
                
                ExerciseListView(viewModel: ExerciseListViewModel())
                    .tabItem {
                        Label("Exercices", systemImage: "flame")
                    }
                
                SleepHistoryView(viewModel: SleepHistoryViewModel())
                    .tabItem {
                        Label("Sommeil", systemImage: "moon")
                }
            }
        }
    }
}

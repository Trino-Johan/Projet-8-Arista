import SwiftUI

struct ExerciseListView: View {
    @ObservedObject var viewModel: ExerciseListViewModel
    @State private var showingAddExerciseView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.backgroundColor.ignoresSafeArea()
                
                if viewModel.exercises.isEmpty {
                    emptyStateView
                } else {
                    exerciseList
                }
            }
            .navigationTitle("Exercices")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddExerciseView = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(AppTheme.primaryColor)
                    }
                }
            }
            .sheet(isPresented: $showingAddExerciseView) {
                AddExerciseView(viewModel: AddExerciseViewModel())
                    .onDisappear {
                        viewModel.reload()
                    }
            }
        }
    }
    
    // MARK: - Composants
    
    private var emptyStateView: some View {
        VStack(spacing: AppTheme.spacing.large) {
            Image(systemName: "figure.run.circle")
                .font(.system(size: 80))
                .foregroundColor(AppTheme.textSecondary)
            
            Text("Aucun exercice")
                .font(AppTheme.title)
                .foregroundColor(AppTheme.textPrimary)
            
            Text("Ajoutez votre premier exercice\npour commencer à suivre votre activité")
                .font(AppTheme.body)
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
            
            Button(action: {
                showingAddExerciseView = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Ajouter un exercice")
                }
                .primaryButtonStyle()
            }
            .padding(.horizontal, AppTheme.spacing.extraLarge)
        }
        .padding(AppTheme.spacing.large)
    }
    
    private var exerciseList: some View {
        ScrollView {
            LazyVStack(spacing: AppTheme.spacing.medium) {
                ForEach(viewModel.exercises) { exercise in
                    ExerciseCard(exercise: exercise)
                }
            }
            .padding(AppTheme.spacing.medium)
        }
    }
}

// MARK: - ExerciseCard

struct ExerciseCard: View {
    let exercise: Exercise
    
    var body: some View {
        HStack(spacing: AppTheme.spacing.medium) {
            // Icône de catégorie
            Circle()
                .fill(categoryColor.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: iconForCategory)
                        .font(.system(size: 24))
                        .foregroundColor(categoryColor)
                )
            
            // Informations
            VStack(alignment: .leading, spacing: AppTheme.spacing.tiny) {
                Text(exercise.category ?? "Inconnu")
                    .font(AppTheme.headline)
                    .foregroundColor(AppTheme.textPrimary)
                
                HStack(spacing: AppTheme.spacing.small) {
                    Label("\(Int(exercise.duration)) min", systemImage: "clock.fill")
                    Label("Intensité \(Int(exercise.intensity))", systemImage: "bolt.fill")
                }
                .font(AppTheme.caption)
                .foregroundColor(AppTheme.textSecondary)
                
                if let startDate = exercise.startDate {
                    Text(startDate.formatted(date: .abbreviated, time: .shortened))
                        .font(AppTheme.small)
                        .foregroundColor(AppTheme.textSecondary)
                }
            }
            
            Spacer()
            
            // Indicateur d'intensité
            IntensityIndicator(intensity: Int(exercise.intensity))
        }
        .padding(AppTheme.spacing.medium)
        .cardStyle()
    }
    
    private var iconForCategory: String {
        switch exercise.category {
        case "Football":
            return "sportscourt"
        case "Natation":
            return "figure.pool.swim"
        case "Running":
            return "figure.run"
        case "Marche":
            return "figure.walk"
        case "Cyclisme":
            return "bicycle"
        case "Fitness":
            return "dumbbell.fill"
        default:
            return "figure.strengthtraining.traditional"
        }
    }
    
    private var categoryColor: Color {
        switch exercise.category {
        case "Football":
            return .green
        case "Natation":
            return .blue
        case "Running":
            return .orange
        case "Marche":
            return .purple
        case "Cyclisme":
            return .red
        case "Fitness":
            return .pink
        default:
            return AppTheme.primaryColor
        }
    }
}

// MARK: - IntensityIndicator

struct IntensityIndicator: View {
    var intensity: Int
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(index < intensityLevel ? colorForIntensity : Color.gray.opacity(0.3))
                    .frame(width: 4, height: 20)
            }
        }
    }
    
    private var intensityLevel: Int {
        switch intensity {
        case 0...3:
            return 1
        case 4...6:
            return 2
        case 7...10:
            return 3
        default:
            return 0
        }
    }
    
    private var colorForIntensity: Color {
        switch intensity {
        case 0...3:
            return .green
        case 4...6:
            return .orange
        case 7...10:
            return .red
        default:
            return .gray
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview {
    ExerciseListView(viewModel: ExerciseListViewModel())
}
#endif

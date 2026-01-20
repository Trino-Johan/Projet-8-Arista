import SwiftUI

struct AddExerciseView: View {
    @ObservedObject var viewModel: AddExerciseViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showingValidationError = false
    @State private var validationMessage = ""
    
    let categories = ["Football", "Running", "Natation", "Cyclisme", "Marche", "Fitness"]
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.backgroundColor.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppTheme.spacing.large) {
                        // En-tête
                        headerSection
                        
                        // Formulaire
                        formSection
                        
                        // Bouton d'ajout
                        addButton
                    }
                    .padding(AppTheme.spacing.medium)
                }
            }
            .navigationTitle("Nouvel exercice")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.textSecondary)
                }
            }
            .alert("Formulaire incomplet", isPresented: $showingValidationError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(validationMessage)
            }
        }
    }
    
    // MARK: - Composants
    
    private var headerSection: some View {
        VStack(spacing: AppTheme.spacing.small) {
            Image(systemName: "figure.run.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.primaryColor)
            
            Text("Ajouter un exercice")
                .font(AppTheme.headline)
                .foregroundColor(AppTheme.textPrimary)
        }
        .padding(.top, AppTheme.spacing.medium)
    }
    
    private var formSection: some View {
        VStack(spacing: AppTheme.spacing.medium) {
            // Catégorie
            VStack(alignment: .leading, spacing: AppTheme.spacing.small) {
                Label("Catégorie", systemImage: "tag.fill")
                    .font(AppTheme.body)
                    .foregroundColor(AppTheme.textPrimary)
                
                Picker("Catégorie", selection: $viewModel.category) {
                    Text("Sélectionnez...").tag("")
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(.menu)
                .padding()
                .background(AppTheme.cardBackground)
                .cornerRadius(AppTheme.cornerRadius.medium)
            }
            
            // Durée
            VStack(alignment: .leading, spacing: AppTheme.spacing.small) {
                Label("Durée (minutes)", systemImage: "clock.fill")
                    .font(AppTheme.body)
                    .foregroundColor(AppTheme.textPrimary)
                
                HStack {
                    Slider(value: Binding(
                        get: { Double(viewModel.duration) },
                        set: { viewModel.duration = Int($0) }
                    ), in: 0...180, step: 5)
                    
                    Text("\(viewModel.duration) min")
                        .font(AppTheme.headline)
                        .foregroundColor(AppTheme.primaryColor)
                        .frame(width: 70, alignment: .trailing)
                }
                .padding()
                .background(AppTheme.cardBackground)
                .cornerRadius(AppTheme.cornerRadius.medium)
            }
            
            // Intensité
            VStack(alignment: .leading, spacing: AppTheme.spacing.small) {
                Label("Intensité", systemImage: "bolt.fill")
                    .font(AppTheme.body)
                    .foregroundColor(AppTheme.textPrimary)
                
                HStack {
                    Slider(value: Binding(
                        get: { Double(viewModel.intensity) },
                        set: { viewModel.intensity = Int($0) }
                    ), in: 0...10, step: 1)
                    
                    Text("\(viewModel.intensity)/10")
                        .font(AppTheme.headline)
                        .foregroundColor(intensityColor)
                        .frame(width: 70, alignment: .trailing)
                }
                .padding()
                .background(AppTheme.cardBackground)
                .cornerRadius(AppTheme.cornerRadius.medium)
            }
            
            // Date et heure
            VStack(alignment: .leading, spacing: AppTheme.spacing.small) {
                Label("Date et heure", systemImage: "calendar")
                    .font(AppTheme.body)
                    .foregroundColor(AppTheme.textPrimary)
                
                DatePicker("", selection: $viewModel.startTime)
                    .datePickerStyle(.compact)
                    .padding()
                    .background(AppTheme.cardBackground)
                    .cornerRadius(AppTheme.cornerRadius.medium)
            }
        }
    }
    
    private var addButton: some View {
        Button(action: {
            if validateForm() {
                viewModel.addExercise()
                dismiss()
            } else {
                showingValidationError = true
            }
        }) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("Ajouter l'exercice")
            }
            .primaryButtonStyle()
        }
        .opacity(isFormValid ? 1.0 : 0.6)
        .padding(.top, AppTheme.spacing.medium)
    }
    
    // MARK: - Validation
    
    private var isFormValid: Bool {
        !viewModel.category.isEmpty &&
        viewModel.duration > 0 &&
        viewModel.intensity > 0
    }
    
    private func validateForm() -> Bool {
        if viewModel.category.isEmpty {
            validationMessage = "Veuillez sélectionner une catégorie d'exercice."
            return false
        }
        
        if viewModel.duration == 0 {
            validationMessage = "La durée doit être supérieure à 0 minutes."
            return false
        }
        
        if viewModel.intensity == 0 {
            validationMessage = "L'intensité doit être supérieure à 0."
            return false
        }
        
        return true
    }
    
    private var intensityColor: Color {
        switch viewModel.intensity {
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
    AddExerciseView(viewModel: AddExerciseViewModel())
}
#endif

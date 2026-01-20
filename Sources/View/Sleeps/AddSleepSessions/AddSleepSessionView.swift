import SwiftUI

struct AddSleepSessionView: View {
    @ObservedObject var viewModel: AddSleepSessionViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showingValidationError = false
    @State private var validationMessage = ""
    
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
            .navigationTitle("Nouvelle session")
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
            Image(systemName: "moon.stars.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.primaryColor)
            
            Text("Ajouter une session de sommeil")
                .font(AppTheme.headline)
                .foregroundColor(AppTheme.textPrimary)
        }
        .padding(.top, AppTheme.spacing.medium)
    }
    
    private var formSection: some View {
        VStack(spacing: AppTheme.spacing.medium) {
            // Durée
            VStack(alignment: .leading, spacing: AppTheme.spacing.small) {
                Label("Durée du sommeil", systemImage: "clock.fill")
                    .font(AppTheme.body)
                    .foregroundColor(AppTheme.textPrimary)
                
                VStack(alignment: .leading, spacing: AppTheme.spacing.small) {
                    HStack {
                        Slider(value: Binding(
                            get: { Double(viewModel.duration) },
                            set: { viewModel.duration = Int($0) }
                        ), in: 0...720, step: 15)
                        
                        Text(formattedDuration)
                            .font(AppTheme.headline)
                            .foregroundColor(AppTheme.primaryColor)
                            .frame(width: 90, alignment: .trailing)
                    }
                    
                    Text("Glissez pour ajuster la durée (0 à 12 heures)")
                        .font(AppTheme.small)
                        .foregroundColor(AppTheme.textSecondary)
                }
                .padding()
                .background(AppTheme.cardBackground)
                .cornerRadius(AppTheme.cornerRadius.medium)
            }
            
            // Qualité
            VStack(alignment: .leading, spacing: AppTheme.spacing.small) {
                Label("Qualité du sommeil", systemImage: "star.fill")
                    .font(AppTheme.body)
                    .foregroundColor(AppTheme.textPrimary)
                
                VStack(spacing: AppTheme.spacing.small) {
                    HStack(spacing: AppTheme.spacing.medium) {
                        ForEach(1...5, id: \.self) { index in
                            Button(action: {
                                viewModel.quality = index
                            }) {
                                Image(systemName: index <= viewModel.quality ? "star.fill" : "star")
                                    .font(.system(size: 32))
                                    .foregroundColor(index <= viewModel.quality ? .yellow : .gray.opacity(0.3))
                            }
                        }
                    }
                    
                    Text(qualityDescription)
                        .font(AppTheme.caption)
                        .foregroundColor(AppTheme.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppTheme.cardBackground)
                .cornerRadius(AppTheme.cornerRadius.medium)
            }
            
            // Date et heure de début
            VStack(alignment: .leading, spacing: AppTheme.spacing.small) {
                Label("Date et heure de début", systemImage: "calendar")
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
                viewModel.addSleepSession()
                dismiss()
            } else {
                showingValidationError = true
            }
        }) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("Ajouter la session")
            }
            .primaryButtonStyle()
        }
        .opacity(isFormValid ? 1.0 : 0.6)
        .padding(.top, AppTheme.spacing.medium)
    }
    
    // MARK: - Helpers
    
    private var formattedDuration: String {
        let hours = viewModel.duration / 60
        let minutes = viewModel.duration % 60
        
        if hours > 0 && minutes > 0 {
            return "\(hours)h \(minutes)min"
        } else if hours > 0 {
            return "\(hours)h"
        } else {
            return "\(minutes)min"
        }
    }
    
    private var qualityDescription: String {
        switch viewModel.quality {
        case 5:
            return "Excellent - Sommeil très réparateur"
        case 4:
            return "Bon - Sommeil réparateur"
        case 3:
            return "Moyen - Sommeil correct"
        case 2:
            return "Faible - Sommeil agité"
        case 1:
            return "Très faible - Sommeil perturbé"
        default:
            return "Sélectionnez une qualité"
        }
    }
    
    // MARK: - Validation
    
    private var isFormValid: Bool {
        viewModel.duration > 0 && viewModel.quality > 0
    }
    
    private func validateForm() -> Bool {
        if viewModel.duration == 0 {
            validationMessage = "La durée doit être supérieure à 0 minutes."
            return false
        }
        
        if viewModel.quality == 0 {
            validationMessage = "Veuillez sélectionner une qualité de sommeil (1 à 5 étoiles)."
            return false
        }
        
        return true
    }
}

// MARK: - Preview

#if DEBUG
#Preview {
    AddSleepSessionView(viewModel: AddSleepSessionViewModel())
}
#endif


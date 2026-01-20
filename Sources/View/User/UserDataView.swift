import SwiftUI

struct UserDataView: View {
    @ObservedObject var viewModel: UserDataViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.backgroundColor.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppTheme.spacing.large) {
                        // En-tête avec avatar
                        userHeaderSection
                        
                        // Informations utilisateur
                        userInfoCard
                        
                        Spacer()
                    }
                    .padding(AppTheme.spacing.medium)
                }
            }
            .navigationTitle("Profil")
        }
    }
    
    // MARK: - Composants
    
    private var userHeaderSection: some View {
        VStack(spacing: AppTheme.spacing.medium) {
            // Avatar circulaire
            Circle()
                .fill(AppTheme.primaryColor.opacity(0.2))
                .frame(width: 100, height: 100)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 50))
                        .foregroundColor(AppTheme.primaryColor)
                )
            
            // Nom complet
            Text("\(viewModel.firstName) \(viewModel.lastName)")
                .font(AppTheme.title)
                .foregroundColor(AppTheme.textPrimary)
        }
        .padding(.top, AppTheme.spacing.large)
    }
    
    private var userInfoCard: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacing.medium) {
            Text("Informations")
                .font(AppTheme.headline)
                .foregroundColor(AppTheme.textPrimary)
            
            Divider()
            
            // Prénom
            InfoRow(
                icon: "person.fill",
                label: "Prénom",
                value: viewModel.firstName.isEmpty ? "Non renseigné" : viewModel.firstName
            )
            
            // Nom
            InfoRow(
                icon: "person.fill",
                label: "Nom",
                value: viewModel.lastName.isEmpty ? "Non renseigné" : viewModel.lastName
            )
        }
        .padding(AppTheme.spacing.medium)
        .cardStyle()
    }
}

// MARK: - Composant InfoRow

struct InfoRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: AppTheme.spacing.medium) {
            Image(systemName: icon)
                .foregroundColor(AppTheme.primaryColor)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: AppTheme.spacing.tiny) {
                Text(label)
                    .font(AppTheme.caption)
                    .foregroundColor(AppTheme.textSecondary)
                
                Text(value)
                    .font(AppTheme.body)
                    .foregroundColor(AppTheme.textPrimary)
            }
            
            Spacer()
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview {
    UserDataView(viewModel: UserDataViewModel())
}
#endif

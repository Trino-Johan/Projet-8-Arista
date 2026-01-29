import SwiftUI

struct SleepHistoryView: View {
    @ObservedObject var viewModel: SleepHistoryViewModel
    @State private var showingAddSleepView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.backgroundColor.ignoresSafeArea()
                
                if viewModel.sleepSessions.isEmpty {
                    emptyStateView
                } else {
                    sleepList
                }
            }
            .navigationTitle("Sommeil")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddSleepView = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(AppTheme.primaryColor)
                    }
                }
            }
            .sheet(isPresented: $showingAddSleepView) {
                AddSleepSessionView(viewModel: AddSleepSessionViewModel())
                    .onDisappear {
                        viewModel.reload()
                    }
            }
        }
    }
    
    // MARK: - Composants
    
    private var emptyStateView: some View {
        VStack(spacing: AppTheme.spacing.large) {
            Image(systemName: "moon.stars.circle")
                .font(.system(size: 80))
                .foregroundColor(AppTheme.textSecondary)
            
            Text("Aucune session")
                .font(AppTheme.title)
                .foregroundColor(AppTheme.textPrimary)
            
            Text("Ajoutez votre première session\npour suivre votre sommeil")
                .font(AppTheme.body)
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
            
            Button(action: {
                showingAddSleepView = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Ajouter une session")
                }
                .primaryButtonStyle()
            }
            .padding(.horizontal, AppTheme.spacing.extraLarge)
        }
        .padding(AppTheme.spacing.large)
    }
    
    private var sleepList: some View {
        ScrollView {
            LazyVStack(spacing: AppTheme.spacing.medium) {
                ForEach(viewModel.sleepSessions) { session in
                    SleepCard(session: session)
                }
            }
            .padding(AppTheme.spacing.medium)
        }
    }
}

// MARK: - SleepCard

struct SleepCard: View {
    let session: Sleep
    
    var body: some View {
        HStack(spacing: AppTheme.spacing.medium) {
            // Icône de sommeil
            Circle()
                .fill(qualityColor.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: "moon.zzz.fill")
                        .font(.system(size: 24))
                        .foregroundColor(qualityColor)
                )
            
            // Informations
            VStack(alignment: .leading, spacing: AppTheme.spacing.tiny) {
                Text("Session de sommeil")
                    .font(AppTheme.headline)
                    .foregroundColor(AppTheme.textPrimary)
                
                HStack(spacing: AppTheme.spacing.small) {
                    Label("\(formattedDuration)", systemImage: "clock.fill")
                    Label("Qualité \(Int(session.quality))/5", systemImage: "star.fill")
                }
                .font(AppTheme.caption)
                .foregroundColor(AppTheme.textSecondary)
                
                if let startDate = session.startDate {
                    Text(startDate.formatted(date: .abbreviated, time: .shortened))
                        .font(AppTheme.small)
                        .foregroundColor(AppTheme.textSecondary)
                }
            }
            
            Spacer()
            
            // Indicateur de qualité
            QualityIndicator(quality: Int(session.quality))
        }
        .padding(AppTheme.spacing.medium)
        .cardStyle()
    }
    
    private var formattedDuration: String {
        let hours = Int(session.duration) / 60
        let minutes = Int(session.duration) % 60
        
        if hours > 0 && minutes > 0 {
            return "\(hours)h\(minutes)min"
        } else if hours > 0 {
            return "\(hours)h"
        } else {
            return "\(minutes)min"
        }
    }
    
    private var qualityColor: Color {
        switch Int(session.quality) {
        case 5:
            return .green
        case 4:
            return .blue
        case 3:
            return .orange
        case 2:
            return .red
        case 1:
            return .purple
        default:
            return .gray
        }
    }
}

// MARK: - QualityIndicator

struct QualityIndicator: View {
    var quality: Int
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= quality ? "star.fill" : "star")
                    .font(.system(size: 12))
                    .foregroundColor(index <= quality ? .yellow : .gray.opacity(0.3))
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview {
    SleepHistoryView(viewModel: SleepHistoryViewModel())
}
#endif

import SwiftUI

struct AppTheme {
    
    // MARK: - Colors
    
    static let primaryColor = Color.blue
    static let secondaryColor = Color.orange
    static let accentColor = Color.green
    static let destructiveColor = Color.red
    
    static let backgroundColor = Color(.systemBackground)
    static let cardBackground = Color(.secondarySystemBackground)
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
    
    // MARK: - police
    
    static let largeTitle = Font.system(size: 28, weight: .bold)
    static let title = Font.system(size: 22, weight: .bold)
    static let headline = Font.system(size: 18, weight: .semibold)
    static let body = Font.system(size: 16, weight: .regular)
    static let caption = Font.system(size: 14, weight: .regular)
    static let small = Font.system(size: 12, weight: .regular)
    
    // MARK: - Sapces
    
    static let spacing = Spacing()
    
    struct Spacing {
        let tiny: CGFloat = 4
        let small: CGFloat = 8
        let medium: CGFloat = 16
        let large: CGFloat = 24
        let extraLarge: CGFloat = 32
    }
    
    // MARK: - Radius
    
    static let cornerRadius = CornerRadius()
    
    struct CornerRadius {
        let small: CGFloat = 8
        let medium: CGFloat = 12
        let large: CGFloat = 16
    }
    
    // MARK: - shadows
    
    static let shadow = Shadow()
    
    struct Shadow {
        let light = (color: Color.black.opacity(0.1), radius: CGFloat(4), x: CGFloat(0), y: CGFloat(2))
        let medium = (color: Color.black.opacity(0.15), radius: CGFloat(8), x: CGFloat(0), y: CGFloat(4))
    }
}

// MARK: - Extensions

extension View {
    func cardStyle() -> some View {
        self
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadius.medium)
            .shadow(
                color: AppTheme.shadow.light.color,
                radius: AppTheme.shadow.light.radius,
                x: AppTheme.shadow.light.x,
                y: AppTheme.shadow.light.y
            )
    }
    
    func primaryButtonStyle() -> some View {
        self
            .font(AppTheme.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(AppTheme.primaryColor)
            .cornerRadius(AppTheme.cornerRadius.medium)
    }
}

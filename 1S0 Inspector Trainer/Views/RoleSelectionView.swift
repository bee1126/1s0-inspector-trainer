import SwiftUI

struct RoleSelectionView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let title: String
    let subtitle: String
    let onSelect: (TrainingRole) -> Void

    @State private var selectedRole: TrainingRole? = nil
    @State private var appeared = false

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                VStack(spacing: 0) {

                    // ── Header ────────────────────────────────────
                    Spacer()
                        .frame(height: 60)

                    VStack(spacing: 10) {
                        // Shield icon
                        Image(systemName: "shield.checkered")
                            .font(.system(size: 44, weight: .light))
                            .foregroundColor(AppTheme.primary)
                            .shadow(color: AppTheme.primary.opacity(0.4), radius: 12, x: 0, y: 0)
                            .padding(.bottom, 4)

                        Text("1S0 INSPECTOR TRAINER")
                            .font(AppFont.mono(11))
                            .foregroundColor(AppTheme.primary)
                            .tracking(2)

                        Text(title)
                            .font(AppFont.title(28))
                            .foregroundColor(AppTheme.text)
                            .multilineTextAlignment(.center)

                        Text(subtitle)
                            .font(AppFont.body(14))
                            .foregroundColor(AppTheme.muted)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 36)

                    // ── Role Cards ────────────────────────────────
                    VStack(spacing: 14) {
                        ForEach(TrainingRole.allCases) { role in
                            Button {
                                selectRole(role)
                            } label: {
                                OnboardingRoleCard(
                                    role: role,
                                    isSelected: selectedRole == role
                                )
                            }
                            .buttonStyle(.plain)
                            .frame(maxWidth: .infinity, minHeight: AppSpacing.minTapTarget, alignment: .leading)
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(role.displayName)
                            .accessibilityValue(selectedRole == role ? "Selected" : "Not selected")
                            .accessibilityHint("Double tap to choose this role.")
                        }
                    }
                    .padding(.horizontal, AppSpacing.screenPadding)

                    // ── Confirm Button ────────────────────────────
                    Button {
                        if let role = selectedRole {
                            onSelect(role)
                        }
                    } label: {
                        HStack {
                            Text("Continue")
                                .font(AppFont.subtitle(16))
                            Spacer()
                            Image(systemName: "arrow.right")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(selectedRole != nil ? AppTheme.primary : AppTheme.border)
                        )
                        .foregroundColor(selectedRole != nil ? AppTheme.bg : AppTheme.muted)
                    }
                    .disabled(selectedRole == nil)
                    .padding(.horizontal, AppSpacing.screenPadding)
                    .padding(.top, 28)

                    // ── Footer ────────────────────────────────────
                    Text("Not an official Air Force product. Training aids only.")
                        .font(AppFont.mono(10))
                        .foregroundColor(AppTheme.muted.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.top, 32)
                        .padding(.bottom, 40)
                }
            }
            .scrollIndicators(.hidden)
        }
        .opacity(appeared ? 1 : 0)
        .onAppear {
            if reduceMotion {
                appeared = true
            } else {
                withAnimation(.easeIn(duration: 0.4)) {
                    appeared = true
                }
            }
        }
    }

    private func selectRole(_ role: TrainingRole) {
        if reduceMotion {
            selectedRole = role
        } else {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedRole = role
            }
        }
    }
}

// MARK: - Onboarding Role Card

private struct OnboardingRoleCard: View {
    let role: TrainingRole
    let isSelected: Bool

    private var icon: String {
        switch role {
        case .oneS0: return "eye.trianglebadge.exclamationmark"
        }
    }

    private var tagline: String {
        switch role {
        case .oneS0: return "Enterprise oversight & inspections"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(isSelected ? AppTheme.primary.opacity(0.15) : AppTheme.border.opacity(0.5))
                        .frame(width: 44, height: 44)

                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? AppTheme.primary : AppTheme.muted)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(role.shortName)
                        .font(AppFont.mono(20))
                        .foregroundColor(isSelected ? AppTheme.primary : AppTheme.text)

                    Text(role.displayName)
                        .font(AppFont.body(13))
                        .foregroundColor(AppTheme.muted)
                }

                Spacer()

                // Selection indicator
                ZStack {
                    Circle()
                        .stroke(isSelected ? AppTheme.primary : AppTheme.border, lineWidth: 2)
                        .frame(width: 22, height: 22)

                    if isSelected {
                        Circle()
                            .fill(AppTheme.primary)
                            .frame(width: 12, height: 12)
                    }
                }
            }

            // Description
            Text(tagline)
                .font(AppFont.body(13))
                .foregroundColor(AppTheme.muted.opacity(0.8))

            // Context
            Text(role.lessonContext)
                .font(AppFont.mono(11))
                .foregroundColor(AppTheme.muted.opacity(0.6))
                .lineSpacing(2)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(AppTheme.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(isSelected ? AppTheme.primary.opacity(0.6) : AppTheme.border, lineWidth: isSelected ? 1.5 : 1)
        )
        .shadow(color: isSelected ? AppTheme.primary.opacity(0.12) : .clear, radius: 8, x: 0, y: 2)
        .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

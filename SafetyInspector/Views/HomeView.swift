import SwiftUI

struct HomeView: View {
    private let modules = TrainingContent.modules

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("1S0 Professional Training Kit")
                            .font(AppFont.title(28))
                            .foregroundColor(.white)
                        Text("Interactive safety training for Air Force 1S0 inspectors")
                            .font(AppFont.body(15))
                            .foregroundColor(Color.white.opacity(0.85))
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Mission Brief")
                                .font(AppFont.subtitle(18))
                                .foregroundColor(AppTheme.charcoal)

                            Text("Build habits that prevent accidents and keep teams mission-ready. Work through scenarios, quick checks, and score-based progression.")
                                .font(AppFont.body(14))
                                .foregroundColor(AppTheme.charcoal.opacity(0.8))

                            HStack(spacing: 8) {
                                TagPill(text: "On-device")
                                TagPill(text: "Scenario-driven")
                                TagPill(text: "Standards aligned")
                            }
                        }
                    }

                    NavigationLink {
                        ModuleListView()
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Start Training")
                                    .font(AppFont.subtitle(18))
                                Text("Choose a module and run the scenario")
                                    .font(AppFont.body(13))
                                    .foregroundColor(.white.opacity(0.85))
                            }
                            Spacer()
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 22))
                        }
                        .foregroundColor(.white)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(AppTheme.blue)
                        )
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Modules")
                            .font(AppFont.subtitle(18))
                            .foregroundColor(.white)

                        ForEach(modules.prefix(3), id: \.id) { module in
                            ModulePreviewRow(module: module)
                        }
                    }

                    Text("Not an official Air Force product. Training aids only.")
                        .font(AppFont.body(12))
                        .foregroundColor(Color.white.opacity(0.75))
                        .padding(.top, 10)
                }
                .padding(20)
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

struct ModulePreviewRow: View {
    let module: TrainingModule

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(AppTheme.safetyGreen.opacity(0.9))
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: "checkmark.shield")
                        .foregroundColor(.white)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(module.title)
                    .font(AppFont.subtitle(16))
                    .foregroundColor(.white)
                Text(module.subtitle)
                    .font(AppFont.body(12))
                    .foregroundColor(Color.white.opacity(0.7))
            }
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.15))
        )
    }
}

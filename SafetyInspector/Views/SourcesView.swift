import SwiftUI

struct SourcesView: View {
    private let references = TrainingContent.references

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("Sources")
                        .font(AppFont.title(26))
                        .foregroundColor(.white)

                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Reference Materials")
                                .font(AppFont.subtitle(18))
                                .foregroundColor(AppTheme.charcoal)

                            ForEach(references, id: \.id) { source in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(source.title)
                                        .font(AppFont.subtitle(15))
                                        .foregroundColor(AppTheme.charcoal)
                                    Text(source.date)
                                        .font(AppFont.mono(11))
                                        .foregroundColor(AppTheme.charcoal.opacity(0.6))
                                    Text(source.notes)
                                        .font(AppFont.body(12))
                                        .foregroundColor(AppTheme.charcoal.opacity(0.7))
                                }
                                Divider().opacity(0.3)
                            }
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Disclaimer")
                                .font(AppFont.subtitle(16))
                                .foregroundColor(AppTheme.charcoal)
                            Text("This application is not an official Air Force product. It is a training aid intended to reinforce published guidance and OSHA standards. Always follow unit-specific procedures and the most current official publications.")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.charcoal.opacity(0.7))
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Sources")
        .navigationBarTitleDisplayMode(.inline)
    }
}

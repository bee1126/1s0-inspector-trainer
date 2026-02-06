import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.shield.fill")
                .font(.system(size: 40))
                .foregroundColor(.blue)
            Text("Hello, Preview!")
                .font(.title2)
                .foregroundColor(.primary)
            Text("This is a simple ContentView for previewing.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

// A SwiftUI preview.
#Preview {
    ContentView()
}

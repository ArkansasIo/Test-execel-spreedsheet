import SwiftUI

struct ChatRequest: Encodable {
    let message: String
    let context: String
}

struct ChatResponse: Decodable {
    let model: String
    let response: String
}

@MainActor
final class AgentViewModel: ObservableObject {
    @Published var prompt = ""
    @Published var answer = "Connect this client to your AetherForge bridge running on a trusted computer."
    @Published var isLoading = false
    @Published var errorMessage: String?

    // Replace with the bridge URL reachable from your iPhone/iPad.
    let bridgeURL = URL(string: "http://127.0.0.1:8787")!

    func send() async {
        let trimmed = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            var request = URLRequest(url: bridgeURL.appendingPathComponent("chat"))
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(
                ChatRequest(
                    message: trimmed,
                    context: "AetherForge: 64-bit default; datapath widths up to 1024 bits by emulation; 9.99 GHz CPU/GPU values are simulation targets; 24 virtual SSDs × 32 TB = 768 TB raw logical capacity."
                )
            )
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }
            let result = try JSONDecoder().decode(ChatResponse.self, from: data)
            answer = "[\(result.model)]\n\(result.response)"
        } catch {
            errorMessage = "Could not reach the AetherForge bridge. Check that it is running and bridgeURL is correct. Details: \(error.localizedDescription)"
        }
    }
}

struct ContentView: View {
    @StateObject private var agent = AgentViewModel()

    var body: some View {
        NavigationStack {
            Form {
                Section("AetherForge Virtual Compute Rack") {
                    LabeledContent("Build ID", value: "AFVCR-2026-10-29-001")
                    LabeledContent("Version", value: "1.1.0")
                    LabeledContent("Developer", value: "Stephen Delaine junior")
                    Text("Excel stores configuration. Ollama runs on a separate computer.")
                        .font(.footnote)
                }
                Section("Ask the local agent") {
                    TextField("Ask about CPU, GPU, memory, storage…", text: $agent.prompt, axis: .vertical)
                        .lineLimit(2...5)
                    Button {
                        Task { await agent.send() }
                    } label: {
                        if agent.isLoading { ProgressView() } else { Text("Send to Ollama") }
                    }
                    .disabled(agent.isLoading || agent.prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    if let error = agent.errorMessage {
                        Text(error).foregroundStyle(.red)
                    }
                    Text(agent.answer).textSelection(.enabled)
                }
            }
            .navigationTitle("AetherForge")
        }
    }
}

@main
struct AetherForgeApp: App {
    var body: some Scene {
        WindowGroup { ContentView() }
    }
}

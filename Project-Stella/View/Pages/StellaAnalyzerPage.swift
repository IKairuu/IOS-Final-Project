import SwiftUI

struct StellaAnalyzerPage: View {
    @Environment(AppState.self) private var appState
    @State private var messages: [MessageModel] = []
    @State private var input: String = ""
    @State private var isWaiting: Bool = false
    @State private var socket = MessageSocketController(agent: .analyze)
    var body: some View {
        VStack(spacing: 0) {
            ChatMessageList(messages: messages, initials: userInitials(appState.currentUser?.username), isTyping: isWaiting)
            ChatInputBar(text: $input, onSend: sendMessage)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Design().secondaryColor)
        .cornerRadius(15)
        .onAppear(perform: connectSocket)
        .task { await loadHistory() }
        .onDisappear { socket.disconnect() }
        .onChange(of: socket.status) {
            if socket.status == .disconnected {
                isWaiting = false
            }
        }
    }
    
    private func sendMessage() {
        let content = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !content.isEmpty else { return }
        let message = MessageModel(sender: .user, content: content)
        messages.append(message)
        if socket.send(message, userId: appState.currentUser?.id) {
            isWaiting = true
        }
        input = ""
    }
    
    private func connectSocket() {
        if messages.isEmpty {
            messages = appState.analyzerMessages
        }
        socket.onMessage = {
            messages.append($0)
            isWaiting = false
        }
        socket.connect(token: appState.token)
    }
    
    private func loadHistory() async {
        await MessageController().fetchMessages(token: appState.token, agent: .analyze, appState: appState)
        messages = MessageController().mergeMessages(history: appState.analyzerMessages, local: messages)
    }
}

#Preview {
    StellaAnalyzerPage()
        .environment(AppState())
        .padding(20)
}

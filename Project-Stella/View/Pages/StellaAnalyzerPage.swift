//
//  StellaAnalyzerPage.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/14/26.
//

import SwiftUI

struct StellaAnalyzerPage: View {
    @Environment(AppState.self) private var appState
    @State private var messages: [MessageModel] = []
    @State private var input: String = ""
    @State private var socket = MessageSocketController(agent: .analyzer)
    var body: some View {
        VStack(spacing: 0) {
            ChatMessageList(messages: messages, initials: userInitials(appState.currentUser?.username))
            ChatInputBar(text: $input, onSend: sendMessage)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Design().secondaryColor)
        .cornerRadius(15)
        .onAppear(perform: connectSocket)
        .task { await loadHistory() }
        .onDisappear { socket.disconnect() }
    }
    
    private func sendMessage() {
        let content = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !content.isEmpty else { return }
        let message = MessageModel(sender: .user, content: content)
        messages.append(message)
        socket.send(message, userId: appState.currentUser?.id)
        input = ""
    }
    
    private func connectSocket() {
        if messages.isEmpty {
            messages = appState.analyzerMessages
        }
        socket.onMessage = { messages.append($0) }
        socket.connect(token: appState.token)
    }
    
    private func loadHistory() async {
        await MessageController().fetchMessages(token: appState.token, agent: .analyzer, appState: appState)
        messages = MessageController().mergeMessages(history: appState.analyzerMessages, local: messages)
    }
}

#Preview {
    StellaAnalyzerPage()
        .environment(AppState())
        .padding(20)
}

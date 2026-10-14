//
//  StellaAnalyzerPage.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/14/26.
//

import SwiftUI

struct StellaAnalyzerPage: View {
    @Environment(AppState.self) private var appState
    @State private var messages: [MessageModel] = testAnalyzerMessages
    @State private var input: String = ""
    var body: some View {
        VStack(spacing: 0) {
            ChatMessageList(messages: messages, initials: userInitials(appState.currentUser?.username))
            ChatInputBar(text: $input, onSend: sendMessage)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Design().secondaryColor)
        .cornerRadius(15)
    }
    
    // Placeholder: appends the message locally until the Analyzer agent is wired in
    private func sendMessage() {
        let content = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !content.isEmpty else { return }
        messages.append(MessageModel(sender: .user, content: content))
        input = ""
    }
}

#Preview {
    StellaAnalyzerPage()
        .environment(AppState())
        .padding(20)
}

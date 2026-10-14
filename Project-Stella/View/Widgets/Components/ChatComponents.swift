//
//  ChatComponents.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/14/26.
//

import SwiftUI

struct StellaPageSelector: View {
    @Binding var selected: Int
    var body: some View {
        HStack(spacing: 0) {
            Button {
                selected = 0
            } label: {
                Text("STELLA Analyzer")
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(selected == 0 ? Design().mainTheme : Design().secondaryColor)
            }
            Button {
                selected = 1
            } label: {
                Text("STELLA Task Generator")
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(selected == 1 ? Design().mainTheme : Design().secondaryColor)
            }
        }
        .background(Design().secondaryColor)
        .cornerRadius(10)
    }
}

struct ChatAvatar: View {
    let sender: MessageSender
    let initials: String
    var body: some View {
        Group {
            if sender == .user {
                Text(initials)
                    .font(.custom("Roboto-Bold", size: 20))
                    .foregroundColor(.black)
                    .frame(width: 50, height: 50)
                    .background(Color.white)
            }
            else {
                Image("chat logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .background(Color.black)
            }
        }
        .clipShape(Circle())
        .overlay(Circle().stroke(Design().mainTheme, lineWidth: 3))
        .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
    }
}

struct ChatBubble: View {
    let message: MessageModel
    let initials: String
    
    private var isUser: Bool { message.sender == .user }
    private var timestamp: String {
        let time = message.sentAt.formatted(.dateTime.hour(.twoDigits(amPM: .abbreviated)).minute(.twoDigits))
        return Calendar.current.isDateInToday(message.sentAt) ? "Today, \(time)" : message.sentAt.formatted(date: .abbreviated, time: .shortened)
    }
    
    var body: some View {
        VStack(alignment: isUser ? .leading : .trailing, spacing: 4) {
            HStack(alignment: isUser ? .center : .top, spacing: 8) {
                if !isUser {
                    ChatAvatar(sender: message.sender, initials: initials)
                }
                Text(message.content)
                    .font(.custom("Roboto-Regular", size: 13))
                    .lineSpacing(4)
                    .foregroundColor(.black)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Design().mainTheme)
                    .cornerRadius(10)
                if isUser {
                    ChatAvatar(sender: message.sender, initials: initials)
                }
            }
            Text(timestamp)
                .font(.custom("Roboto-Regular", size: 9))
                .foregroundColor(.black)
                .padding(.leading, isUser ? 0 : 58)
                .padding(.trailing, isUser ? 58 : 0)
        }
    }
}

struct ChatMessageList: View {
    let messages: [MessageModel]
    let initials: String
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(messages) { message in
                        ChatBubble(message: message, initials: initials)
                            .id(message.id)
                    }
                }
                .padding(12)
            }
            .onAppear {
                if let lastId = messages.last?.id {
                    proxy.scrollTo(lastId, anchor: .bottom)
                }
            }
            .onChange(of: messages.count) {
                if let lastId = messages.last?.id {
                    withAnimation {
                        proxy.scrollTo(lastId, anchor: .bottom)
                    }
                }
            }
        }
    }
}

struct ChatInputBar: View {
    @Binding var text: String
    let onSend: () -> Void
    var body: some View {
        HStack(spacing: 10) {
            TextField("Enter message here...", text: $text)
                .font(.custom("Roboto-Regular", size: 14))
                .padding(.horizontal, 10)
                .frame(height: 36)
                .background(Design().secondaryColor)
                .cornerRadius(10)
                .onSubmit(onSend)
            Button(action: onSend) {
                Image(systemName: "paperplane")
                    .font(.system(size: 24))
                    .foregroundColor(.black)
            }
            .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(10)
        .background(Design().mainTheme)
    }
}

func userInitials(_ username: String?) -> String {
    guard let username, !username.isEmpty else { return "US" }
    return String(username.prefix(2)).uppercased()
}

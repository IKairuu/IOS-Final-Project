//
//  MessageController.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/29/26.
//

import SwiftUI

enum MessageSortOrder {
    case oldestFirst, newestFirst
}

struct MessageController {
    func fetchMessages(token: String?, agent: StellaAgent, appState: AppState, order: MessageSortOrder = .oldestFirst) async {
        guard let token else { return }
        do {
            let messages = sortMessages(try await MessageDatasource().getMessages(token: token, agent: agent), order: order)
            switch agent {
            case .analyzer:
                appState.analyzerMessages = messages
            case .generator:
                appState.generatorMessages = messages
            case .summary:
                break
            }
        } catch {
            print("fetchMessages(\(agent.rawValue)) error: \(error)")
        }
    }

    func sortMessages(_ messages: [MessageModel], order: MessageSortOrder = .oldestFirst) -> [MessageModel] {
        messages.sorted {
            switch order {
            case .oldestFirst:
                return $0.sentAt < $1.sentAt
            case .newestFirst:
                return $0.sentAt > $1.sentAt
            }
        }
    }

    func mergeMessages(history: [MessageModel], local: [MessageModel], order: MessageSortOrder = .oldestFirst) -> [MessageModel] {
        let unsaved = local.filter { message in
            !history.contains { $0.sender == message.sender && $0.content == message.content }
        }
        return sortMessages(history + unsaved, order: order)
    }
}

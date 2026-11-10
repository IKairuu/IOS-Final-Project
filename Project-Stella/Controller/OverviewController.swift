import SwiftUI

@MainActor
@Observable
final class OverviewController {
    var summary: String?
    var isLoading: Bool = false
    let socket = MessageSocketController(agent: .summary)
    private var userId: String?

    func load(token: String?, userId: String?) {
        guard summary == nil, !isLoading else { return }
        self.userId = userId
        isLoading = true
        socket.onConnect = { [weak self] in
            self?.sendRequest()
        }
        socket.onClose = { [weak self] in
            self?.isLoading = false
        }
        socket.onMessage = { [weak self] message in
            guard let self else { return }
            self.summary = message.content
            self.isLoading = false
            self.socket.disconnect()
        }
        if socket.status == .connected {
            sendRequest()
        } else {
            socket.connect(token: token)
            if socket.status == .disconnected {
                isLoading = false
            }
        }
    }

    func reset() {
        socket.onConnect = nil
        socket.onClose = nil
        socket.onMessage = nil
        socket.disconnect()
        summary = nil
        isLoading = false
        userId = nil
    }

    private func sendRequest() {
        guard isLoading else { return }
        socket.requestSummary(userId: userId)
    }
}

import SwiftUI

enum SessionStatus {
    case checking, signedOut, signedIn
}

@Observable
class AppState {
    var token: String?
    var currentUser: UserModel?
    var currentGoogleUid: String?
    var isLoggedIn: Bool = false
    var sessionStatus: SessionStatus = .checking
    var rootId = UUID()
    var analyzerMessages: [MessageModel] = []
    var generatorMessages: [MessageModel] = []
    var overview = OverviewController()
}

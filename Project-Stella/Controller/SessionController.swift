//
//  SessionController.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/28/26.
//

import SwiftUI

struct SessionController {
    func restoreSession(appState: AppState) async {
        SessionStorage().clearIfFreshInstall()
        guard let token = SessionStorage().readToken() else {
            appState.sessionStatus = .signedOut
            return
        }

        do {
            let user = try await SessionDatasource().verifySession(token: token)
            do {
                testTask = try await TaskDatasource().getTasks(token: token)
            } catch let error as URLError where error.code == .badServerResponse {
                throw SessionDatasource.SessionError.rejected
            }
            appState.currentUser = user
            appState.token = token
            appState.isLoggedIn = true
            appState.sessionStatus = .signedIn
        } catch SessionDatasource.SessionError.rejected {
            SessionStorage().deleteToken()
            appState.sessionStatus = .signedOut
        } catch {
            print("restoreSession error: \(error)")
            appState.sessionStatus = .signedOut
        }
    }

    func rememberSession(token: String?, keepSignedIn: Bool) {
        if keepSignedIn, let token {
            SessionStorage().saveToken(token)
        } else {
            SessionStorage().deleteToken()
        }
    }

    func logout(appState: AppState) async {
        if let token = SessionStorage().readToken() {
            SessionStorage().deleteToken()
            await SessionDatasource().logoutSession(token: token)
        }
        appState.token = nil
        appState.currentUser = nil
        appState.currentGoogleUid = nil
        appState.isLoggedIn = false
        testTask = []
        appState.sessionStatus = .signedOut
        appState.rootId = UUID()
    }
}

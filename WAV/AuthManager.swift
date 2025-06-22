//
//  AuthManager.swift
//  WAV
//
//  Created by Karthik Gurram on 2025-06-21.
//

import Foundation
import FirebaseAuth

final class AuthManager: ObservableObject {
    static let shared = AuthManager()

    @Published var userID: String? = nil

    private init() {}

    func signInAnonymouslyIfNeeded(completion: @escaping (String?) -> Void) {
        if let currentUser = Auth.auth().currentUser {
            self.userID = currentUser.uid
            completion(currentUser.uid)
        } else {
            Auth.auth().signInAnonymously { [weak self] result, error in
                if let error = error {
                    print("Auth failed: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                guard let user = result?.user else {
                    completion(nil)
                    return
                }
                print("Signed in anonymously with UID: \(user.uid)")
                self?.userID = user.uid
                completion(user.uid)
            }
        }
    }
}

//
//  FirebaseStorageManager.swift
//  WAV
//
//  Created by Karthik Gurram on 2025-06-21.
//

import Foundation
import FirebaseStorage

final class FirebaseStorageManager {
    static let shared = FirebaseStorageManager()

    private let storage = Storage.storage()

    func uploadRecording(fileURL: URL, userId: String, completion: @escaping (Bool) -> Void) {
        let fileName = fileURL.lastPathComponent
        let storageRef = storage.reference().child("recordings/\(userId)/\(fileName)")

        storageRef.putFile(from: fileURL, metadata: nil) { metadata, error in
            if let error = error {
                print("❌ Upload failed: \(error.localizedDescription)")
                completion(false)
            } else {
                print("✅ Uploaded: \(fileName)")
                completion(true)
            }
        }
    }
}

//
//  AudioPlaybackService.swift
//  WAV
//
//  Created by Karthik Gurram on 2025-06-21.
//

import Foundation
import AVFoundation

final class AudioPlaybackService: NSObject, ObservableObject {
    static let shared = AudioPlaybackService()

    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?

    @Published var currentlyPlayingFile: String?
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 1 // Default to 1 to avoid div by zero
    @Published var isScrubbing: Bool = false

    func play(fileName: String) {
        stop()

        let url = getDocumentsDirectory().appendingPathComponent(fileName)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()

            currentlyPlayingFile = fileName
            duration = audioPlayer?.duration ?? 1
            currentTime = 0

            startTimer()

            print("🔊 Playing: \(fileName)")
        } catch {
            print("❌ Playback failed: \(error.localizedDescription)")
            currentlyPlayingFile = nil
        }
    }

    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
        currentlyPlayingFile = nil
        stopTimer()
        currentTime = 0
    }

    func seek(to time: TimeInterval) {
        guard let player = audioPlayer else { return }
        player.currentTime = time
        currentTime = time
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self = self,
                  let player = self.audioPlayer,
                  player.isPlaying,
                  !self.isScrubbing else { return }
            self.currentTime = player.currentTime
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func getDurationString(for fileName: String) -> String {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            let duration = player.duration
            let minutes = Int(duration) / 60
            let seconds = Int(duration) % 60
            return String(format: "%d:%02d", minutes, seconds)
        } catch {
            return "--:--"
        }
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

extension AudioPlaybackService: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        currentlyPlayingFile = nil
        stopTimer()
        currentTime = 0
        print("✅ Finished playing.")
    }
}

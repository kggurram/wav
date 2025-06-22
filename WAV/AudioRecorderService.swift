//
//  AudioRecorderService.swift
//  WAV
//
//  Created by Karthik Gurram on 2025-06-21.
//

import Foundation
import AVFoundation
import AVFAudio
import Combine

final class AudioRecorderService: NSObject, ObservableObject {
    static let shared = AudioRecorderService()

    private var audioRecorder: AVAudioRecorder?
    private var recordingSession: AVAudioSession = AVAudioSession.sharedInstance()

    private var meterTimer: Timer?

    @Published var isRecording: Bool = false
    @Published var currentFileURL: URL?
    @Published var liveAmplitude: Float = 0.0

    override private init() {
        super.init()
        requestPermission()
    }

    private func requestPermission() {
        AVAudioApplication.requestRecordPermission { granted in
            DispatchQueue.main.async {
                if granted {
                    print("✅ Microphone permission granted.")
                } else {
                    print("❌ Microphone permission denied.")
                }
            }
        }
    }

    func startRecording(fileName: String) {
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)

            let fileURL = getDocumentsDirectory().appendingPathComponent("\(fileName).wav")

            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1,
                AVLinearPCMBitDepthKey: 16,
                AVLinearPCMIsBigEndianKey: false,
                AVLinearPCMIsFloatKey: false
            ]

            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()

            startMetering()

            isRecording = true
            currentFileURL = fileURL

            print("🎙️ Recording started: \(fileURL)")
        } catch {
            print("❌ Failed to start recording: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        stopMetering()
        isRecording = false
        print("🛑 Recording stopped.")
    }

    private func startMetering() {
        meterTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self = self, let recorder = self.audioRecorder else { return }
            recorder.updateMeters()
            let raw = recorder.averagePower(forChannel: 0)
            let normalized = pow(10, raw / 20) // Convert dB to linear 0...1
            self.liveAmplitude = normalized
        }
    }

    private func stopMetering() {
        meterTimer?.invalidate()
        meterTimer = nil
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

extension AudioRecorderService: AVAudioRecorderDelegate {}

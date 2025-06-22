//
//  ContentView.swift
//  WAV
//
//  Created by Karthik Gurram on 2025-06-21.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseStorage
import FirebaseAuth


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var recordings: [Recording]

    @StateObject private var recorder = AudioRecorderService.shared
    @StateObject private var player = AudioPlaybackService.shared

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(recordings) { recording in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(recording.title.isEmpty ? "Untitled" : recording.title)
                                    .font(.headline)

                                Spacer()

                                Button(action: {
                                    if player.currentlyPlayingFile == recording.fileName {
                                        player.stop()
                                    } else {
                                        player.play(fileName: recording.fileName)
                                    }
                                }) {
                                    Image(systemName: player.currentlyPlayingFile == recording.fileName ? "stop.fill" : "play.fill")
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(Color.gray.opacity(0.3))
                                        .clipShape(Circle())
                                }
                            }

                            HStack(spacing: 16) {
                                Text("Created: \(recording.createdAt.formatted(date: .abbreviated, time: .shortened))")
                                Text("Duration: \(player.getDurationString(for: recording.fileName))")
                            }
                            .font(.caption)

                            if let waveform = waveformForRecording(recording) {
                                WaveformView(amplitudes: waveform)
                            }

                            // ✅ Scrubbable playback bar
                            if player.currentlyPlayingFile == recording.fileName {
                                PlaybackBarView(player: player, fileName: recording.fileName)
                            }
                        }

                    }
                    .onDelete(perform: deleteItems)
                }

                Divider()

                // Live Waveform & Record Button
                if recorder.isRecording {
                    LiveWaveformView(amplitude: recorder.liveAmplitude)
                        .padding(.top)

                    Button(action: toggleRecording) {
                        Label("Stop Recording", systemImage: "stop.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding()
                } else {
                    Button(action: toggleRecording) {
                        Label("Start Recording", systemImage: "mic.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding()
                }
            }
            .navigationTitle("WAV Recordings")
        }
    }

    private func toggleRecording() {
        if recorder.isRecording {
            recorder.stopRecording()
            if let fileURL = recorder.currentFileURL {
                let fileName = fileURL.lastPathComponent
                let newRecording = Recording(fileName: fileName, title: fileName)
                modelContext.insert(newRecording)
                
                // Delay upload to give iOS time to write the file
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    if let userId = Auth.auth().currentUser?.uid {
                        FirebaseStorageManager.shared.uploadRecording(fileURL: fileURL, userId: userId) { success in
                            if success {
                                print("✅ File uploaded. Ready for analysis.")
                            } else {
                                print("❌ Upload failed (after delay)")
                            }
                        }
                    }
                }
            }
        } else {
            let fileName = "WAV-\(UUID().uuidString.prefix(8))"
            recorder.startRecording(fileName: String(fileName))
        }
    }

    private func waveformForRecording(_ recording: Recording) -> [Float]? {
        let url = getDocumentsDirectory().appendingPathComponent(recording.fileName)
        return WaveformExtractor.extractAmplitudes(from: url)
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(recordings[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Recording.self, inMemory: true)
}

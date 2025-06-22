//
//  PlaybackBarView.swift
//  WAV
//
//  Created by Karthik Gurram on 2025-06-21.
//

import SwiftUI

struct PlaybackBarView: View {
    @ObservedObject var player: AudioPlaybackService
    let fileName: String

    var body: some View {
        VStack {
            Slider(value: Binding(
                get: { player.currentTime },
                set: { newValue in
                    player.currentTime = newValue
                    if player.isScrubbing {
                        player.seek(to: newValue)
                    }
                }
            ), in: 0...player.duration, onEditingChanged: { isEditing in
                player.isScrubbing = isEditing
                if !isEditing {
                    player.seek(to: player.currentTime)
                }
            })
            .accentColor(.green)

            HStack {
                Text(format(player.currentTime))
                Spacer()
                Text(format(player.duration))
            }
            .font(.caption)
            .foregroundStyle(.gray)
        }
        .padding(.horizontal)
    }

    private func format(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

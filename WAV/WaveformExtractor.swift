//
//  WaveformExtractor.swift
//  WAV
//
//  Created by Karthik Gurram on 2025-06-21.
//

import Foundation
import AVFoundation

class WaveformExtractor {
    static func extractAmplitudes(from url: URL, sampleCount: Int = 200) -> [Float] {
        guard let file = try? AVAudioFile(forReading: url) else {
            print("❌ Failed to open audio file.")
            return []
        }

        let format = file.processingFormat
        let frameCount = UInt32(file.length)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
            print("❌ Failed to create buffer.")
            return []
        }

        do {
            try file.read(into: buffer)
        } catch {
            print("❌ Error reading buffer: \(error.localizedDescription)")
            return []
        }

        guard let floatChannelData = buffer.floatChannelData?[0] else {
            print("❌ No channel data found.")
            return []
        }

        let totalFrames = Int(buffer.frameLength)
        let step = max(totalFrames / sampleCount, 1)
        var amplitudes: [Float] = []

        for i in stride(from: 0, to: totalFrames, by: step) {
            let sample = floatChannelData[i]
            amplitudes.append(abs(sample))
        }


        return amplitudes
    }
}

//
//  WaveformView.swift
//  WAV
//
//  Created by Karthik Gurram on 2025-06-21.
//

import SwiftUI
import AVFoundation

struct WaveformView: View {
    let amplitudes: [Float]

    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let width = geometry.size.width
            let spacing = width / CGFloat(amplitudes.count)

            Canvas { context, size in
                for (index, amplitude) in amplitudes.enumerated() {
                    let x = CGFloat(index) * spacing
                    let y = CGFloat(amplitude) * height * 4
                    let rect = CGRect(x: x, y: height / 2 - y, width: 1, height: y * 2)
                    context.fill(Path(rect), with: .color(.blue))
                }
            }
        }
        .frame(height: 80)
        .cornerRadius(8)
        .padding(.horizontal)
    }
}

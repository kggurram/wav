//
//  LiveWaveformView.swift
//  WAV
//
//  Created by Karthik Gurram on 2025-06-21.
//

import SwiftUI

struct LiveWaveformView: View {
    let amplitude: Float

    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let lineHeight = max(2, CGFloat(amplitude) * height * 4)

            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.blue)
                    .frame(height: lineHeight)
                    .padding(.horizontal)
                Spacer()
            }
            .animation(.easeOut(duration: 0.05), value: lineHeight)
        }
        .frame(height: 50)
        .cornerRadius(8)
        .padding(.horizontal)
    }
}

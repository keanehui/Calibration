//
//  Waveform.swift
//  Calibration
//
//  Created by Keane Hui on 31/3/2022.
//

import SwiftUI

struct AudioWaveform: View {
    var message: String?
    
    var body: some View {
        VStack {
            ZStack(alignment: .center) {
                Group {
//                    WaveForm(color: .red, amplify: 140, isReverse: true)
//                        .offset(x: UIScreen.main.bounds.width*0.5, y: 0)
//                    WaveForm(color: .red, amplify: 140, isReverse: true)
//                        .offset(x: -UIScreen.main.bounds.width*0.5, y: 0)
                    WaveForm(color: .purple, amplify: 150, isReverse: false)
                    WaveForm(color: .cyan, amplify: 140, isReverse: true)
                    WaveForm(color: .green, amplify: 150, isReverse: false)
                        .offset(x: UIScreen.main.bounds.width*0.5, y: 0)
                    WaveForm(color: .green, amplify: 150, isReverse: false)
                        .offset(x: -UIScreen.main.bounds.width*0.5, y: 0)
                }
                .opacity(0.5)
                Image(systemName: "mic.circle.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 60, weight: .light, design: .rounded))
                    .offset(x: 0, y: 10)
            }
            .frame(maxWidth: .infinity, maxHeight: 100)
            Text(message ?? "")
                .fontWeight(.bold)
                .foregroundColor(.accentColor)
                .multilineTextAlignment(.center)
        }
        
    }
}

struct WaveForm: View {
    var color: Color
    var amplify: CGFloat
    var isReverse: Bool = false
    
    var body: some View {
        TimelineView(.animation) { timeLine in
            Canvas { context, size in
                let timeNow = timeLine.date.timeIntervalSinceReferenceDate
                let angle = timeNow.remainder(dividingBy: 2)
                let offset = angle * size.width
                
                context.translateBy(x: isReverse ? -offset : offset, y: 0)
                context.fill(getPath(size: size), with: .color(color))
                context.translateBy(x: -size.width, y: 0)
                context.fill(getPath(size: size), with: .color(color))
                context.translateBy(x: size.width*2, y: 0)
                context.fill(getPath(size: size), with: .color(color))

            }
        }
        
        
    }
    
    private func getPath(size: CGSize) -> Path {
        return Path { path in
            let midHeight = size.height / 2
            let width = size.width
            path.move(to: CGPoint(x: 0, y: midHeight))
            path.addCurve(to: CGPoint(x: width, y: midHeight), control1: CGPoint(x: width*0.4, y: midHeight+amplify), control2: CGPoint(x: width*0.65, y: midHeight-amplify))
            path.addLine(to: CGPoint(x: width, y: size.height))
            path.addLine(to: CGPoint(x: 0, y: size.height))
        }
    }
}

struct Waveform_Previews: PreviewProvider {
    static var previews: some View {
        AudioWaveform(message: "Answer by directly saying it. ")
    }
}

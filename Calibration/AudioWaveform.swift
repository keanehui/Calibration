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
//                    WaveForm(color: .red, amplify: 150)
//                        .reverse()
//                        .offset(x: UIScreen.main.bounds.width*0.5, y: 0)
//                    WaveForm(color: .red, amplify: 150)
//                        .reverse()
//                        .offset(x: -UIScreen.main.bounds.width*0.5, y: 0)
                    WaveForm(color: .purple, amplify: 150)
                        .reverse()
                    WaveForm(color: .green, amplify: 150)
                        .offset(x: UIScreen.main.bounds.width*0.5, y: 0)
                    WaveForm(color: .green, amplify: 150)
                        .offset(x: -UIScreen.main.bounds.width*0.5, y: 0)
                    WaveForm(color: .cyan, amplify: 140)
                }
                .opacity(0.7)
                Image(systemName: "waveform.and.mic")
                    .foregroundColor(.white)
                    .font(.system(size: 50, weight: .light, design: .rounded))
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
    
    var body: some View {
        TimelineView(.animation) { timeLine in
            Canvas { context, size in
                let timeNow = timeLine.date.timeIntervalSinceReferenceDate
                let angle = timeNow.remainder(dividingBy: 2)
                let offset = angle * size.width
                
                context.translateBy(x: offset, y: 0)
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
            path.addCurve(to: CGPoint(x: width, y: midHeight), control1: CGPoint(x: width*0.5, y: midHeight+amplify), control2: CGPoint(x: width*0.5, y: midHeight-amplify))
            path.addLine(to: CGPoint(x: width, y: size.height))
            path.addLine(to: CGPoint(x: 0, y: size.height))
        }
    }
    
    func reverse() -> some View {
        return self.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
    }
}

struct Waveform_Previews: PreviewProvider {
    static var previews: some View {
        AudioWaveform(message: "Answer by directly saying it. ")
    }
}

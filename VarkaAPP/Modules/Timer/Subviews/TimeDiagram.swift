//
//  TimeDiagram.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 27.03.2021.
//

import SwiftUI

struct TimeDiagram: View {
    let width: CGFloat
    let height: CGFloat
    let totalSeconds: Int
    let remainingSeconds: Int
    
    var toValue: CGFloat {
        (0.4 + CGFloat(remainingSeconds) / CGFloat(totalSeconds) * 0.6)
    }
    
    private var stringTimerTime: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds - (minutes * 60)
        let stringSeconds = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        
        return remainingSeconds > 0
            ? "\(minutes):\(stringSeconds)"
            : "Готово!"
    }
    
    var body: some View {
        ZStack {
            ZStack {
                Circle()
                    .trim(from: 0.4, to: 1)
                    .stroke(style: .init(lineWidth: 20, lineCap: .round,
                                         lineJoin: .round, miterLimit: 0,
                                         dash: [], dashPhase: 0))
                    .foregroundColor(Color.init(.systemGray4))
                
                Circle()
                    .trim(from: 0.4, to: toValue)
                    .stroke(style: .init(lineWidth: 20, lineCap: .round,
                                         lineJoin: .round, miterLimit: 0,
                                         dash: [], dashPhase: 0))
                    .foregroundColor(Color.init(VarkaColors.mainColor))
            }
            .rotationEffect(.degrees(18))
            .scaleEffect(0.8)
            
            Text(stringTimerTime)
                .font(.title)
        }
        .padding(.bottom, -50)
        .frame(width: width, height: height)
    }
}

struct TimeDiagram_Previews: PreviewProvider {
    static var previews: some View {
        TimeDiagram(width: 200,
                    height: 150,
                    totalSeconds: 600,
                    remainingSeconds: 307)
    }
}

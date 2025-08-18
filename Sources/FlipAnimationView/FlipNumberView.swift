//
//  SwiftUIView.swift
//  FlipAnimationView
//
//  Created by Tomoaki Yagishita on 2025/08/17.
//

import SwiftUI
import OSLog

extension OSLog {
    //static fileprivate var logger = Logger(subsystem: "com.smalldesksfotware.FlipAnimationView", category: "FlipNumberView")
    static fileprivate var logger = Logger(.disabled)
}

public struct FlipNumberView: View {
    @Binding var displayNumber: Int
    let prevNumber: Int? = nil
    let digitNum: Int
    let animationDuration: Double
    
    public init(_ number: Binding<Int>, digitNum: Int = 1, animationDuration: Double = 0.3) {
        self._displayNumber = number
        self.digitNum = digitNum
        self.animationDuration = animationDuration
    }
    public var body: some View {
        HStack(spacing: 1) {
            ForEach((0..<digitNum).reversed(), id: \.self) { digit in
                SingleFlipNumberView($displayNumber, at: digit, animationDuration: animationDuration)
            }
        }
    }
}

public struct SingleFlipNumberView: View {
    @Binding var displayNumber: Int
    let digitIndex: Int
    let animationDuration: Double

    @State var nowDigit: Int
    @State var prevDigit: Int?
    @State private var upAnim = false
    @State private var downAnim = false

    public init(_ given: Binding<Int>, at digitIndex: Int, animationDuration: Double = 0.3) {
        self._displayNumber = given
        self.digitIndex = digitIndex
        self.animationDuration = animationDuration

        self.nowDigit = given.wrappedValue.digit(at: digitIndex)
        self.prevDigit = nil
    }
    public var body: some View {
        VStack {
            VStack(spacing:0) {
                ZStack {
                    Image("L\(nowDigit)_01", bundle: .module).resizable().scaledToFit()
                    if let prevNumber = prevDigit {
                        Image("L\(prevNumber)_01", bundle: .module).resizable().scaledToFit()
                            .rotation3DEffect(Angle(degrees: upAnim  ? -89.99 : 0),
                                              axis: (x:1,y:0,z:0), anchor: .bottom, anchorZ: 0, perspective: 0.05)
                    }
                }
                ZStack {
                    if let prevNumber = prevDigit {
                        Image("L\(prevNumber)_02", bundle: .module).resizable().scaledToFit()
                    }
                    Image("L\(nowDigit)_02", bundle: .module).resizable().scaledToFit()
                        .rotation3DEffect(Angle(degrees: downAnim ? 0 : 89.99),
                                          axis: (x:1,y:0,z:0), anchor: .top, anchorZ: 0, perspective: 0.05)
                        .zIndex(1.0)
                }
            }
            .onAppear {
                if prevDigit==nil { upAnim = true; downAnim = true; prevDigit = displayNumber; return }
                if prevDigit==displayNumber { upAnim = true; downAnim = true; return }
                animate()
            }
            .onChange(of: displayNumber, perform: { new in
                OSLog.logger.debug("onChange@SingleFlipNumberView2 new:\(new) prev:\(prevDigit ?? -99) displayNumer: \(displayNumber)")
                nowDigit = new.digit(at: digitIndex)
                if nowDigit == prevDigit { upAnim = true; downAnim = true; return }
                animate()
            })
        }
    }
    func animate() {
        upAnim = false
        downAnim = false
        withAnimation(Animation.linear(duration: animationDuration/2.0)){
            upAnim = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+animationDuration/2.0) {
            withAnimation(Animation.linear(duration: animationDuration/2.0)){
                downAnim = true
                prevDigit = nowDigit
            }
        }
    }
}

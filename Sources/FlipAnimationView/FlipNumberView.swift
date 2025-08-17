//
//  SwiftUIView.swift
//  FlipAnimationView
//
//  Created by Tomoaki Yagishita on 2025/08/17.
//

import SwiftUI

public struct CurrentNextNumber: NumberForFlip {
    public var current: Int
    public var next: Int
    public init(_ current: Int,_ next: Int) {
        self.current = current
        self.next = next
    }
    
    public func updated(_ diff: Int) -> CurrentNextNumber {
        return CurrentNextNumber(self.current + diff, self.next + diff)
    }
}

public protocol NumberForFlip: Equatable {
    var current: Int { get }
    var next: Int { get }
}


@available(iOS 17.0, macOS 14.0, *)
public struct FlipNumberView<T>: View where T: NumberForFlip{
    @Binding var currentNextNumber: T
    let digitNum: Int

    @State private var upAnim = false
    @State private var downAnim = false
    let animationDuration: Double
    
    public init(currentNextNumber: Binding<T>, digitNum: Int = 1, animationDuration: Double = 0.3) {
        self._currentNextNumber = currentNextNumber
        self.digitNum = digitNum
        self.animationDuration = animationDuration
    }

    public var body: some View {
        VStack {
            VStack(spacing:0) {
                ZStack {
                    Image("L\(currentNextNumber.next)_01", bundle: .module).resizable().scaledToFit()
                    Image("L\(currentNextNumber.current)_01", bundle: .module).resizable().scaledToFit()
                        .rotation3DEffect(Angle(degrees: upAnim  ? -89.99 : 0),
                                          axis: (x:1,y:0,z:0), anchor: .bottom, anchorZ: 0, perspective: 0.05)
                        .opacity((upAnim && downAnim) ? 0.0 : 1.0 )
                }
                ZStack {
                    Image("L\(currentNextNumber.current)_02", bundle: .module).resizable().scaledToFit()
                    Image("L\(currentNextNumber.next)_02", bundle: .module).resizable().scaledToFit()
                        .rotation3DEffect(Angle(degrees: downAnim ? 0 : 89.99),
                                          axis: (x:1,y:0,z:0), anchor: .top, anchorZ: 0, perspective: 0.05)
                        .zIndex(1.0)
                }
            }
            .onChange(of: currentNextNumber, initial: true, { _, new in
                guard new.next < 10 else { fatalError("can not handle")}
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
            }
        }
    }
}


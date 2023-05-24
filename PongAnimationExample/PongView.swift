//
//  PongView.swift
//  PongAnimationExample
//
//  Created by Nicky Taylor on 2/3/23.
//

import SwiftUI

struct PongView: View {
    private static let factorFrameSize: CGFloat = 0.96
    let width: CGFloat
    let height: CGFloat
    var body: some View {
        ZStack {
            TimelineView(.periodic(from: .distantPast, by: 1.0 / 30.0)) { timeline in
                PongViewInternal(width: width * Self.factorFrameSize,
                                 height: height * Self.factorFrameSize,
                                 date: timeline.date)
                
            }
            .frame(width: width * Self.factorFrameSize,
                   height: height * Self.factorFrameSize)
            .background(Color.black)
        }
        .frame(width: width, height: height)
        .background(Color.gray)
    }
    
    private struct PongViewInternal: View {
        
        private static var factorBallSize: CGFloat = 0.06
        private static var factorBallSpeed: CGFloat = 0.01
        
        private static var factorWallSize: CGFloat = 0.06
        
        private static var factorPaddleSizeH: CGFloat = 0.06
        private static var factorPaddleSizeV: CGFloat = 0.18
        
        private static var factorPaddleWallSpacing: CGFloat = 0.06
        
        let width: CGFloat
        let height: CGFloat
        let date: Date
        
        let wallSizeH: CGFloat
        let wallSizeV: CGFloat
        
        let paddleSpacingH: CGFloat
        
        let paddleSize: CGSize
        
        let ballSize: CGSize
        
        @State var ballPosition: CGPoint
        @State var ballSpeed: CGPoint
        
        @State var paddleLeftPosition: CGPoint
        @State var paddleRightPosition: CGPoint
        
        init(width: CGFloat, height: CGFloat, date: Date) {
            self.width = width
            self.height = height
            self.date = date
            
            wallSizeH = width * Self.factorWallSize
            wallSizeV = height * Self.factorWallSize
            
            paddleSpacingH = width * Self.factorPaddleWallSpacing
            
            ballSize = CGSize(width: width * Self.factorBallSize,
                              height: height * Self.factorBallSize)
            
            paddleSize = CGSize(width: width * Self.factorPaddleSizeH,
                                height: height * Self.factorPaddleSizeV)
            
            _ballPosition = State(initialValue: CGPoint(x: width / 2.0 - ballSize.width / 2.0,
                                                        y: height / 2.0 - ballSize.height / 2.0))
            
            _ballSpeed = State(initialValue: CGPoint(x: width * Self.factorBallSpeed * (Bool.random() ? 1.0 : -1.0),
                                                     y: height * Self.factorBallSpeed * (Bool.random() ? 1.0 : -1.0)))
            
            _paddleLeftPosition = State(initialValue: CGPoint(x: wallSizeH + paddleSpacingH,
                                                              y: height / 2.0 - paddleSize.height / 2.0))
            
            _paddleRightPosition = State(initialValue: CGPoint(x: width - (wallSizeH + paddleSpacingH + paddleSize.width),
                                                               y: height / 2.0 - paddleSize.height / 2.0))
            
        }
        
        var body: some View {
            GeometryReader { _ in
                
                Rectangle()
                    .frame(width: width, height: wallSizeV)
                    .offset(x: 0.0, y: 0.0)
                    .foregroundColor(.white)
                
                Rectangle()
                    .frame(width: width, height: wallSizeV)
                    .offset(x: 0.0, y: height - wallSizeV)
                    .foregroundColor(.white)
                
                Rectangle()
                    .frame(width: wallSizeH, height: height)
                    .offset(x: 0.0, y: 0.0)
                    .foregroundColor(.white)
                
                Rectangle()
                    .frame(width: wallSizeH, height: height)
                    .offset(x: width - wallSizeH, y: 0.0)
                    .foregroundColor(.white)
                
                RoundedRectangle(cornerRadius: min(ballSize.width, ballSize.height) * 0.25)
                    .frame(width: ballSize.width, height: ballSize.height)
                    .offset(x: ballPosition.x,
                            y: ballPosition.y)
                    .foregroundColor(.white)
                
                
                RoundedRectangle(cornerRadius: min(paddleSize.width, paddleSize.height) * 0.25)
                    .frame(width: paddleSize.width, height: paddleSize.height)
                    .offset(x: paddleLeftPosition.x,
                            y: paddleLeftPosition.y)
                    .foregroundColor(.white)
                
                RoundedRectangle(cornerRadius: min(paddleSize.width, paddleSize.height) * 0.25)
                    .frame(width: paddleSize.width, height: paddleSize.height)
                    .offset(x: paddleRightPosition.x,
                            y: paddleRightPosition.y)
                    .foregroundColor(.white)
                
            }
            .frame(width: width, height: height)
            .onChange(of: date) { _ in
                update()
            }
        }
        
        func update() {
            
            ballPosition.x += ballSpeed.x
            ballPosition.y += ballSpeed.y
            
            let ballCenterY = ballPosition.y + ballSize.height * 0.5
            
            paddleLeftPosition.y = ballCenterY - paddleSize.height * 0.5
            paddleRightPosition.y = ballCenterY - paddleSize.height * 0.5
            
            if paddleLeftPosition.y < wallSizeV {
                paddleLeftPosition.y = wallSizeV
            }
            
            if paddleLeftPosition.y > height - (wallSizeV + paddleSize.height) {
                paddleLeftPosition.y = height - (wallSizeV + paddleSize.height)
            }
            
            if paddleRightPosition.y < wallSizeV {
                paddleRightPosition.y = wallSizeV
            }
            
            if paddleRightPosition.y > height - (wallSizeV + paddleSize.height) {
                paddleRightPosition.y = height - (wallSizeV + paddleSize.height)
            }
            
            if ballPosition.x > width - (wallSizeH + paddleSpacingH + paddleSize.width + ballSize.width) {
                ballPosition.x = width - (wallSizeH + paddleSpacingH + paddleSize.width + ballSize.width)
                ballSpeed.x = -abs(width * Self.factorBallSpeed * CGFloat.random(in: 0.8...1.2))
            }
            
            if ballPosition.y > height - (wallSizeV + ballSize.height) {
                ballPosition.y = height - (wallSizeV + ballSize.height)
                ballSpeed.y = -abs(height * Self.factorBallSpeed * CGFloat.random(in: 0.8...1.2))
            }
            
            if ballPosition.x < wallSizeH + paddleSpacingH + paddleSize.width {
                ballPosition.x = wallSizeH + paddleSpacingH + paddleSize.width
                ballSpeed.x = abs(width * Self.factorBallSpeed * CGFloat.random(in: 0.8...1.2))
            }
            
            if ballPosition.y < wallSizeV {
                ballPosition.y = wallSizeV
                ballSpeed.y = abs(height * Self.factorBallSpeed * CGFloat.random(in: 0.8...1.2))
            }
        }
    }
}

struct PongView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                Spacer()
                PongView(width: 240.0, height: 240.0)
                Spacer()
            }
        }
    }
}

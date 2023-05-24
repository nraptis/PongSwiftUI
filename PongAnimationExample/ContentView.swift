//
//  ContentView.swift
//  PongAnimationExample
//
//  Created by Nicky Taylor on 2/3/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                PongView(width: 96.0, height: 96.0)
                PongView(width: 96.0, height: 96.0)
                PongView(width: 96.0, height: 96.0)
            }
            HStack {
                PongView(width: 96.0, height: 96.0)
                PongView(width: 96.0, height: 96.0)
                PongView(width: 96.0, height: 96.0)
            }
            HStack {
                PongView(width: 96.0, height: 96.0)
                PongView(width: 96.0, height: 96.0)
                PongView(width: 96.0, height: 96.0)
            }
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

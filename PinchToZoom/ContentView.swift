//
//  ContentView.swift
//  PinchToZoom
//
//  Created by Muhammet Emin Ayhan on 7.10.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            PinchZoomPanResetView()
        }
    }
}

//Define the main view for pinch-to-zoom, pan, and functionalities
struct PinchZoomPanResetView: View {
    // State variable to manage scaling and positioning
    @State private var scale: CGFloat = 1.0 // Current scale factor
    @State private var offset: CGSize = .zero // Current offset for panning
    @State private var lastScaleValue: CGFloat = 1.0 // Last Scale value to calculate scale delta
    @State private var lastOffset: CGSize = .zero // Last offset after panning ends
    
    var body: some View {
        //Define the magnification gesture for pinch-to-zoom
        let magnificationGesture = MagnificationGesture()
            .onChanged { value in
                // Calculete the scale delta since the last uptade
                let delta = value  / self.lastScaleValue
                self.lastScaleValue = value
                let newScale = self.scale * delta
                self.scale = min(max(newScale, 1.0), 5.0)
            }
            .onEnded { _ in
                self.lastScaleValue = 1.0
            }
        
        let dragGesture = DragGesture()
            .onChanged { value in
                self.offset = CGSize(
                    width: value.translation.width + self.offset.width,
                    height: value.translation.height + self.offset.height
                )
            }
            .onEnded { _ in
                self.lastOffset = self.offset
            }
        
        let doubleTapGesture = TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    self.scale = 1.0
                    self.offset = .zero
                    self.lastOffset = .zero
                }
            }
        Image("orman")
            .resizable()
            .scaledToFit()
            .scaleEffect(scale)
            .offset(offset)
            .gesture(
                dragGesture
                    .simultaneously(with: magnificationGesture)
                    .simultaneously(with: doubleTapGesture)
            )
    }
}

#Preview {
    ContentView()
}

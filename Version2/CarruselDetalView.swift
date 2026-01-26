
//  CarruselView.swift
//  Version2
//
//  Created by Fabricio Banda on 22/01/26.
//

import SwiftUI

struct CarruselDetailView: View {
    @Binding var currentIndex:Int
    @GestureState private var dragOffset:CGFloat = 0
    @Environment(FlorViewModel.self) var vm
    
    private func baseXOffset(outerView:CGFloat,cardWidth:CGFloat)-> CGFloat {
        return outerView/2
    - cardWidth / 2
    - (CGFloat(self.currentIndex) * cardWidth)
    + self.dragOffset
    }
    
    var body: some View {
        GeometryReader { outerView in
            
            let cardWidth = outerView.size.width
            
            VStack {
                HStack(spacing:0) {
                    ForEach(self.vm.images,id:\.self) { image in
                        Image(image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: cardWidth)
                    }
                }.frame(width: outerView.size.width,alignment: .leading)
                    .offset(
                        x:baseXOffset(outerView: outerView.size.width, cardWidth: cardWidth)
                        
                    )
                    .gesture(
                        DragGesture()
                            .updating(self.$dragOffset, body: { value, state, _ in
                                state = value.translation.width
                            })
                            .onEnded({ value in
                                
                                let width = cardWidth
                                
                                let traslationX = value.translation.width
                                let predictedTraslationX = value.predictedEndTranslation.width
                                
                                
                                let distanceThreshold = width * 0.55
                                let flickThreshold    = width * 0.40
                                
                                
                                let shouldMove = abs(traslationX) > distanceThreshold || abs(predictedTraslationX) > flickThreshold
                                
                                guard shouldMove else { return }
                                
                             
                                let direction: Int = (predictedTraslationX != 0 ? predictedTraslationX : traslationX) < 0 ? 1 : -1
                                
                                let newIndex = min(max(currentIndex + direction, 0), self.vm.images.count - 1)
                                
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                    currentIndex = newIndex
                                }
                              
                            })
                    )
                
                
            }
            .animation(.linear, value: self.dragOffset)
                .overlay(alignment: .bottom){
                    HStack{
                        ForEach(self.vm.images.indices,id:\.self){ index in
                            
                            Image(systemName: "circle.fill")
                                .font(.caption2)
                                .foregroundStyle(currentIndex == index ? Color.pink:Color.gray.opacity(0.5))
                                .scaleEffect(currentIndex == index ? 1:0.85)
                                .animation(.easeInOut, value: currentIndex)
                            
                            
                        }
                    }.padding()
                }
        
        }
        .aspectRatio(1, contentMode: .fit) 

    }
}


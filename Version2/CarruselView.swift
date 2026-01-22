import SwiftUI

struct CarruselView: View {
    @State private var currentIndex = 0
    
    
    private enum AxisLock {
        case none, horizontal , down
    }
    
    @State private var axis: AxisLock = .none
    
    
    @GestureState private var dragX: CGFloat = 0
    @GestureState private var dragY: CGFloat = 0

    @State private var showCloseButton = true
    @State private var opacity: Double = 1

    @Environment(FlorViewModel.self) var vm


    var body: some View {
        GeometryReader { outerView in
            let cardWidth = outerView.size.width

            VStack {
                Spacer()
                
                HStack(spacing: 0) {
                    ForEach(self.vm.images, id: \.self) { image in
                        Image(image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: cardWidth)
                    }
                }
                .frame(width: outerView.size.width, alignment: .leading)
                .offset(x: baseXOffset(in: outerView, cardWidth: cardWidth) + (axis == .horizontal ? dragX : 0))
                
                Spacer()
            
                if axis != .down{
                    dots
                }
         
            }
            .offset(y: axis == .down ? dragY : 0)
            .background(Color.white.opacity(max(0.30, opacity)))
            .overlay(alignment: .topTrailing) {
                
                if axis != .down && self.showCloseButton{
                    closeButton
                }
         
            }
            .gesture(mainDragGesture(cardWidth: cardWidth))
            .animation(.bouncy,value: axis)
            .animation(.bouncy,value: self.dragX)
            .animation(.bouncy,value: self.showCloseButton)
            .onAppear{
                self.showCloseButton = true
            }
        }
    }


    private var dots: some View {
        HStack {
            ForEach(self.vm.images.indices, id: \.self) { index in
                Image(systemName: "circle.fill")
                    .font(.caption2)
                    .foregroundStyle(currentIndex == index ? Color.pink : Color.gray.opacity(0.5))
                    .scaleEffect(currentIndex == index ? 1 : 0.85)
                    .animation(.easeInOut, value: currentIndex)
            }
        }
    }

    private var closeButton: some View {
        Button {
            vm.isCarruselVisible = false
        } label: {
            Image(systemName: "xmark")
                .foregroundStyle(Color.primary)
                .bold()
                .padding()
        }
    }

   // centrar imagen
    private func baseXOffset(in outerView: GeometryProxy, cardWidth: CGFloat) -> CGFloat {
        outerView.size.width / 2
        - cardWidth / 2
        - (CGFloat(currentIndex) * cardWidth)
    }

    // MARK: - Gesture

    private func mainDragGesture(cardWidth: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 8)
            .onChanged { value in
                
                lockAxisIfNeeded(value)

                if axis == .down {
                    
                    let amount = value.translation.height
                    opacity = max(0.70, 1 - Double(amount / 150))
                    
                } else {
                    opacity = 1
                }
            }
            .updating($dragX) { value, state, _ in
                guard axis == .horizontal else { return }
                state = value.translation.width
            }
            .updating($dragY) { value, state, _ in
                guard axis == .down else { return }
                state = value.translation.height
                print(value.translation.height)
            }
            .onEnded { value in
                defer {
                    axis = .none
                    opacity = 1
                }

    
                if axis == .horizontal {
                    
                    let width = cardWidth
                    let t = value.translation.width
                    let p = value.predictedEndTranslation.width

                    let distanceThreshold = width * 0.55
                    let flickThreshold    = width * 0.40

                    let shouldMove = abs(t) > distanceThreshold || abs(p) > flickThreshold
                    guard shouldMove else { return }

                    let direction: Int = (p != 0 ? p : t) < 0 ? 1 : -1
                    
                    let newIndex = min(max(currentIndex + direction, 0), self.vm.images.count - 1)

                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        currentIndex = newIndex
                    }
                    return
                }

       
                if axis == .down {
                    
                    let threshold: CGFloat = 170
                    
                    let t = value.translation.height
                    let p = value.predictedEndTranslation.height

                    let shouldDismiss = (t > threshold) || (p > threshold)

                    if shouldDismiss {
                        self.showCloseButton = false
                        vm.isCarruselVisible = false
                    } else {
                      
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            opacity = 1
                            self.showCloseButton = true
                        }
                    }
                }
            }
    }

    private func lockAxisIfNeeded(_ value: DragGesture.Value) {
        guard axis == .none else { return }

        let x = value.translation.width
        let y = value.translation.height


        if max(abs(x), y) < 12 { return }
        
        // saber si se arrastro mas en y hacia abajo que x
        if y > abs(x) + 12 {
            axis = .down
        } else if abs(x) > abs(y) + 12 {
            axis = .horizontal
        }
    }
}

#Preview {
    CarruselView().environment(FlorViewModel())
}

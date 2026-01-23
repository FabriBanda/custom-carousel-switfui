//
//  DetailView.swift
//  Version2
//
//  Created by Fabricio Banda on 22/01/26.
//

import SwiftUI

struct DetailView: View {
   
    @Environment(FlorViewModel.self) var vm
    
    @State private var isImagesVisible: Bool = false
    
    @State private var currentIndex: Int = 0
    @State private var showCloseButton = true
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading){
                
                CarruselDetailView(currentIndex: self.$currentIndex)
                    .onTapGesture {
                        
                        self.showCloseButton = true
                        self.isImagesVisible = true
                        
                    }
                
                Text("Arreglo de 24 Rosas Rojas")
                    .multilineTextAlignment(.leading)
                    .font(.title2)
                    .padding()
                    .bold()
                
                
                VStack{
                    Text("Un arreglo fresco y elegante, diseñado para transmitir emociones en cualquier ocasión especial. Flores seleccionadas cuidadosamente y presentadas en un jarrón de vidrio que realza su belleza natural.")
                        .multilineTextAlignment(.leading)
                    
                }.padding(.horizontal)
         
                
                Spacer()
                
                HStack{
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Text("Añadir al carrito")
                            .foregroundStyle(Color(.systemBackground))
                            .bold()
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color.purple,in:RoundedRectangle(cornerRadius: 20))
                .padding()

            }
            
            if self.isImagesVisible {
                CarruselView(currentIndex: self.$currentIndex,isImagesShow: self.$isImagesVisible,showCloseButton: self.$showCloseButton)
                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal:.move(edge: .bottom).combined(with: .opacity)))
                    
            }
        
        }.animation(.easeInOut,value: self.isImagesVisible)
    }
}

#Preview {
    DetailView().environment(FlorViewModel())
}

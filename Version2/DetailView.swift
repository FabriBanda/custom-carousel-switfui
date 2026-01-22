//
//  DetailView.swift
//  Version2
//
//  Created by Fabricio Banda on 22/01/26.
//

import SwiftUI

struct DetailView: View {
   
    let images = ["Flor1","Flor2","Flor3"]
    
    @Environment(FlorViewModel.self) var vm 
    
    var body: some View {
        VStack(alignment: .leading){
            
            TabView {
                ForEach(images, id: \.self) { image in
                    Image(image)
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .onTapGesture {
                            vm.isCarruselVisible = true
                        }
                    
                }
            }
            .tabViewStyle(.page)
            .frame(height: 300)
            
            VStack(alignment: .leading,spacing: 10){
                
                Text("50 Red Roses")
                    .font(.title3)
                
                Text("$1,569")
                    .font(.headline)
                    .bold()
                
            }.padding()
            
            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
            .multilineTextAlignment(.leading)
            .font(.body)
            
            
            Spacer()
        }
    }
}


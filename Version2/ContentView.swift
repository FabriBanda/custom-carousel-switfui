//
//  ContentView.swift
//  Version2
//
//  Created by Fabricio Banda on 22/01/26.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(FlorViewModel.self) var vm

    var body: some View {
        ZStack {
      
            DetailView()
            
            if vm.isCarruselVisible {
                CarruselView()
                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
                    
            }
     
            
  
        }.animation(.easeInOut,value: vm.isCarruselVisible)
    }
}

#Preview {
    ContentView().environment(FlorViewModel())
}

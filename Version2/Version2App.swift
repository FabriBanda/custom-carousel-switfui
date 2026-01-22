//
//  Version2App.swift
//  Version2
//
//  Created by Fabricio Banda on 22/01/26.
//

import SwiftUI

@main
struct Version2App: App {
    @State private var vm = FlorViewModel()
    var body: some Scene {
        WindowGroup {
            DetailView().environment(self.vm)
        }
    }
}

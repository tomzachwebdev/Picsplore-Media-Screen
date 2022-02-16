//
//  ContentView.swift
//  Picsplore Media Selection Screen
//
//  Created by 123456 on 12/26/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        Text("Hello, world!")
//            .padding()
        ImagePickerView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}

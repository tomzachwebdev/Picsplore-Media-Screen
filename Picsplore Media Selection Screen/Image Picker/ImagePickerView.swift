//
//  ImagePickerView.swift
//  Picsplore Media Selection Screen
//
//  Created by 123456 on 12/26/21.
//

import SwiftUI
import AVKit

struct ImagePickerView: View {
    @EnvironmentObject var modelData:ModelData
    
    @State var showingImagePicker:Bool = false
    
    @State var player:AVPlayer? = nil
    
    @State var showAlert:Bool = false
    
    var body: some View {
        NavigationView{
            SelectedMediaView(post: $modelData.mediaItem)
                .toolbar {
                    Button {
                        showingImagePicker.toggle()
                    } label: {
                        Label("add new picture",systemImage: "plus")
                    }.sheet(isPresented: $showingImagePicker, onDismiss: nil) {
                        ImagePickerRepresentable(modelData: _modelData, showAlert: $showAlert)
                    }
                }
        }
        .alert("That Video is too long :(", isPresented: $showAlert, actions: {
            Button(role: .none) {}
            label: {
                Text("Ok")
            }
        }, message: {
            Text("Please select a video that is less than 10 seconds long")
        })
        .onChange(of: modelData.mediaItem) { newValue in
            print("model data changed")
        }
    }
}

struct ImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerView()
            .environmentObject(ModelData())
    }
}

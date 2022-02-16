//
//  PHLivePhotoRepresentable.swift
//  Picsplore Media Selection Screen
//
//  Created by 123456 on 12/26/21.
//

import Foundation
import Photos
import SwiftUI
import PhotosUI

struct PHLivePhotoRepresentable: UIViewRepresentable{
   
    var livePhoto:PHLivePhoto
    
    func updateUIView(_ uiView: PHLivePhotoView, context: Context) {
        uiView.livePhoto = livePhoto
        uiView.startPlayback(with: .hint)
    }
    
    
    func makeUIView(context: Context) -> PHLivePhotoView{
        let livePhotoView = PHLivePhotoView()
        livePhotoView.livePhoto = livePhoto
        livePhotoView.startPlayback(with: .hint)
        return livePhotoView
    }
    
}

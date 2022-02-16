//
//  PostMedia.swift
//  Picsplore Media Selection Screen
//
//  Created by 123456 on 12/26/21.
//

import Foundation
import SwiftUI
import Photos

struct PostMedia:Equatable{
    
    var videoURL:URL? = nil
    var image:Image? = nil
    var livePhoto:PHLivePhoto? = nil
    
    init(videoURL:URL?){
        self.videoURL = videoURL
    }
    
    init(image:Image){
        self.image = image
    }
}

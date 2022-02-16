//
//  MediaView.swift
//  Picsplore Media Selection Screen
//
//  Created by 123456 on 12/26/21.
//

import SwiftUI
import AVKit

struct SelectedMediaView: View {
    
    @Binding var post:PostMedia
    
    var body: some View {
        
        if let livePhoto = post.livePhoto{
            PHLivePhotoRepresentable(livePhoto: livePhoto)
            .scaledToFit()
        }else if let image = post.image{
            image
                .resizable()
                .scaledToFit()
        }else if let url = post.videoURL {
    //            VideoPlayer(player: AVPlayer(url:url))
                PlayerRepresentable(videoURL: url)
                    .scaledToFit()
        }else{
            Text("Tap the + button to add media")
        }
        
    }
}

struct SelectedMediaView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedMediaView(post: .constant(PostMedia(videoURL: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"))))
    }
}

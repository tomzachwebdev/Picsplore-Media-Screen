//
//  PlayerViewRepresentable.swift
//  Picsplore Media Selection Screen
//
//  Created by 123456 on 12/26/21.
//

import Foundation
import SwiftUI

struct PlayerRepresentable:UIViewControllerRepresentable{
    
    var videoURL:URL
    
    func makeUIViewController(context: Context) -> PlayerViewController{
        let playerViewController = PlayerViewController()
//        playerViewController.videoURL = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
        playerViewController.videoURL = videoURL
        return playerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}

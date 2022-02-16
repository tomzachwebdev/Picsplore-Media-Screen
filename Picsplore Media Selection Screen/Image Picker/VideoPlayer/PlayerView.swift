//
//  PlayerView.swift
//  Picsplore Media Selection Screen
//
//  Created by 123456 on 12/26/21.
//

import UIKit
import AVFoundation

/// A simple `UIView` subclass backed by an `AVPlayerLayer` layer.
class PlayerView: UIView {
    
    var player: AVPlayer? {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}


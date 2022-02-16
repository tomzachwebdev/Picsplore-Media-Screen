//
//  Model.swift
//  Picsplore Media Selection Screen
//
//  Created by 123456 on 12/26/21.
//

import Foundation

final class ModelData:ObservableObject{
    @Published var mediaItem:PostMedia = PostMedia(videoURL: nil)
}

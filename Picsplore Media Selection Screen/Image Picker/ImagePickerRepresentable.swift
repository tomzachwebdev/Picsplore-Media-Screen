//
//  ImagePickerRepresentable.swift
//  Picsplore Media Selection Screen
//
//  Created by 123456 on 12/26/21.
//


import Foundation
import SwiftUI
import PhotosUI

struct ImagePickerRepresentable:UIViewControllerRepresentable{

    typealias UIViewType = PHPickerViewController
    
    @EnvironmentObject var modelData: ModelData
    
    @Binding var showAlert:Bool

    
    func makeUIViewController(context: Context) -> PHPickerViewController {
//        let viewcontroller = ImagePickerController()
//        return viewcontroller
         let photoPicker = presentPicker(filter: nil)
         photoPicker.delegate = context.coordinator
         return photoPicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return(Coordinator(self))
    }
    
    class Coordinator:NSObject{
        
        var parent:ImagePickerRepresentable
        
        private var selection = [String: PHPickerResult]()
        private var selectedAssetIdentifiers = [String]()
        private var selectedAssetIdentifierIterator: IndexingIterator<[String]>?
        private var currentAssetIdentifier: String?
        
        init(_ parent:ImagePickerRepresentable){
            self.parent = parent
        }
    }
}

private extension ImagePickerRepresentable{
    
    /// - Tag: PresentPicker
    private func presentPicker(filter: PHPickerFilter?)-> PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        
        // Set the filter type according to the user’s selection.
        configuration.filter = filter
        // Set the mode to avoid transcoding, if possible, if your app supports arbitrary image/video encodings.
        configuration.preferredAssetRepresentationMode = .current
        // Set the selection behavior to respect the user’s selection order.
        configuration.selection = .ordered
        // Set the selection limit to enable multiselection.
//        configuration.selectionLimit = 0
        configuration.selectionLimit = 1
        // Set the preselected asset identifiers with the identifiers that the app tracks.
//        configuration.preselectedAssetIdentifiers = selectedAssetIdentifiers
        configuration.preselectedAssetIdentifiers = []
        
        let picker = PHPickerViewController(configuration: configuration)
//        picker.delegate = self
//        present(picker, animated: true)
        return picker
    }
    
//    private func presentVideoTooLongAlert(){
//        let alert = UIAlertController(title: "Video Too Long", message: "Please select a video with length less than 10 seconds", preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//        alert.addAction(cancelAction)
//        self.picker.present(alert, animated: true, completion: nil)
//    }
    
    
    
    
}


private extension ImagePickerRepresentable.Coordinator {
    
    /// - Tag: LoadItemProvider
    func displayNext() {
        guard let assetIdentifier = selectedAssetIdentifierIterator?.next() else { return }
        currentAssetIdentifier = assetIdentifier
        
        let progress: Progress?
        let itemProvider = selection[assetIdentifier]!.itemProvider
        if itemProvider.canLoadObject(ofClass: PHLivePhoto.self) {
            progress = itemProvider.loadObject(ofClass: PHLivePhoto.self) { [weak self] livePhoto, error in
                DispatchQueue.main.async {
                    self?.handleCompletion(assetIdentifier: assetIdentifier, object: livePhoto, error: error)
                }
            }
        }
        else if itemProvider.canLoadObject(ofClass: UIImage.self) {
            progress = itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    self?.handleCompletion(assetIdentifier: assetIdentifier, object: image, error: error)
                }
            }
        } else if itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
            progress = itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { [weak self] url, error in
                do {
                    guard let url = url, error == nil else {
                        throw error ?? NSError(domain: NSFileProviderErrorDomain, code: -1, userInfo: nil)
                    }
                    let asset = AVAsset(url: url)
                    let duration = asset.duration
                    
                    let localURL = FileManager.default.temporaryDirectory.appendingPathComponent(url.lastPathComponent)
                    try? FileManager.default.removeItem(at: localURL)
                    try FileManager.default.copyItem(at: url, to: localURL)
                    DispatchQueue.main.async { [weak self] in
                        
                        guard let self = self else{ return }
                        
                        if duration > CMTime(value: 1000, timescale: 100){
                            print("video that was selected is too long")
                            self.parent.showAlert = true
                            return
                        }
                        
                        self.handleCompletion(assetIdentifier: assetIdentifier, object: localURL)
                    }
                } catch let catchedError {
                    DispatchQueue.main.async {
                        self?.handleCompletion(assetIdentifier: assetIdentifier, object: nil, error: catchedError)
                    }
                }
            }
        } else {
            progress = nil
        }
        
//        displayProgress(progress)
    }
    
   
    
    func handleCompletion(assetIdentifier: String, object: Any?, error: Error? = nil) {
        guard currentAssetIdentifier == assetIdentifier else { return }
        if let livePhoto = object as? PHLivePhoto {
//            displayLivePhoto(livePhoto)
            print("live photo selectedz")
            parent.modelData.mediaItem.livePhoto = livePhoto
            parent.modelData.mediaItem.videoURL = nil
            parent.modelData.mediaItem.image = nil
//            print("Live photos are not yet supported")
        } else if let image = object as? UIImage {
//            displayImage(image)
            parent.modelData.mediaItem.image = Image(uiImage: image)
            parent.modelData.mediaItem.videoURL = nil
            parent.modelData.mediaItem.livePhoto = nil
        } else if let url = object as? URL {
//            displayVideoPlayButton(forURL: url)
            parent.modelData.mediaItem.videoURL = url
            parent.modelData.mediaItem.image = nil
            parent.modelData.mediaItem.livePhoto = nil
        } else if let error = error {
            print("Couldn't display \(assetIdentifier) with error: \(error)")
//            displayErrorImage()
        } else {
//            displayUnknownImage()
            print("no image found")
        }
    }
    
}


extension ImagePickerRepresentable.Coordinator: PHPickerViewControllerDelegate {
    /// - Tag: ParsePickerResults
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        parent.self.dismiss(animated: true)
        picker.dismiss(animated: true)
        
        let existingSelection = self.selection
        var newSelection = [String: PHPickerResult]()
        for result in results {
            let identifier = result.assetIdentifier!
            newSelection[identifier] = existingSelection[identifier] ?? result
        }
        
        // Track the selection in case the user deselects it later.
        selection = newSelection
        selectedAssetIdentifiers = results.map(\.assetIdentifier!)
        selectedAssetIdentifierIterator = selectedAssetIdentifiers.makeIterator()
        
        if selection.isEmpty {
//            displayEmptyImage()
        } else {
            displayNext()
        }
    }
}

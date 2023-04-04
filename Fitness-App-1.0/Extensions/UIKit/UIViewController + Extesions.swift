//
//  UIViewController + Extesions.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 14.11.2022.
//

import UIKit

extension UIViewController {
    
    func simpleAlert(title: String, message: String?) {
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
    
    func secondAlert(title: String, message: String?, completionHandler: @escaping ()->Void) {
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler()
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func photoPikerAlert(completionHandler: @escaping (UIImagePickerController.SourceType)->Void) {
        
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            let photoPicker = UIImagePickerController.SourceType.camera
            completionHandler(photoPicker)
        }
        
        let libraryAction = UIAlertAction(title: "Photo library", style: .default) { _ in
            let libraryPicker = UIImagePickerController.SourceType.photoLibrary
            completionHandler(libraryPicker)
        }
        
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel)
        
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

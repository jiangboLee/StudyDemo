//
//  ViewController.swift
//  ImageToTextDemo
//
//  Created by ljb48229 on 2018/3/7.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit
import TesseractOCR

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func openPhotoAction(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true)
    }

}
// MARK: - UINavigationControllerDelegate
extension ViewController: UINavigationControllerDelegate {
}

// MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let selectedPhoto = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let scaledImage = selectedPhoto.scaleImage(640) {
            
            dismiss(animated: true, completion: {
                self.performImageRecognition(scaledImage)
            })
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func performImageRecognition(_ image: UIImage) {
        if let tesseract = G8Tesseract(language: "eng") {
            // 2
            tesseract.engineMode = .tesseractCubeCombined
            // 3
            tesseract.pageSegmentationMode = .auto
            // 4
            tesseract.image = image.g8_blackAndWhite()
            // 5
            tesseract.recognize()
            // 6
            textView.text = tesseract.recognizedText
        }
    }
}

    // MARK: - UIImage extension
extension UIImage {
        func scaleImage(_ maxDimension: CGFloat) -> UIImage? {
            
            var scaledSize = CGSize(width: maxDimension, height: maxDimension)
            
            if size.width > size.height {
                let scaleFactor = size.height / size.width
                scaledSize.height = scaledSize.width * scaleFactor
            } else {
                let scaleFactor = size.width / size.height
                scaledSize.width = scaledSize.height * scaleFactor
            }
            
            UIGraphicsBeginImageContext(scaledSize)
            draw(in: CGRect(origin: .zero, size: scaledSize))
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return scaledImage
        }
}







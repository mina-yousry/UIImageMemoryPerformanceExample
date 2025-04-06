//
//  ViewController.swift
//  UIImageMemoryPerformanceExample
//
//  Created by Mina Yousry on 26/03/2025.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imageSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 400)
    var uiImageView: UIImageView?
    var selectedValue = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        uiImageView = UIImageView(frame: CGRect(origin: .init(x: 20, y: 200), size: imageSize))
        uiImageView?.contentMode = .scaleAspectFill
        self.view.addSubview(uiImageView!)
    }
    
    @IBAction func method1(_ sender: Any) {
        selectedValue = "option1"
        openGallery()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        uiImageView?.image = applyNoirFilterUsingUIGraphicsBeginImageContext(image: image)
        dismiss(animated: true, completion: nil)
    }
    
    private func openGallery() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image", "public.movie"]
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func applyNoirFilterUsingUIGraphicsBeginImageContext(image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        
        let filter = CIFilter(name: "CIPhotoEffectNoir")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let outputImage = filter?.outputImage else { return nil }
        let context = CIContext()
        
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let newSize = image.size
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            UIImage(cgImage: cgImage).draw(in: CGRect(origin: .zero, size: newSize))
            let filteredImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return filteredImage
        }
        return nil
    }

}


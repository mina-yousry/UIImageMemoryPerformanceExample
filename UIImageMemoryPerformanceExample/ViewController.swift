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
        
        guard let imageURL = info[.imageURL] as? URL else {
            return
        }
        uiImageView?.image = applyNoirFilterUsingCGImageSource(url: imageURL, imageViewSize: imageSize)
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
    
    func applyNoirFilterUsingCGImageSource(url: URL, imageViewSize: CGSize) -> UIImage? {
        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil),
              let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
            return nil
        }
        let ciImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: "CIPhotoEffectNoir")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        guard let outputImage = filter?.outputImage else { return nil }
        let context = CIContext()
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: max(imageViewSize.width, imageViewSize.height)
        ]
        if let filteredCGImage = context.createCGImage(outputImage, from: outputImage.extent),
           let filteredImageSource = CGImageSourceCreateWithData(UIImage(cgImage: filteredCGImage).pngData()! as CFData, nil),
           let thumbnailCGImage = CGImageSourceCreateThumbnailAtIndex(filteredImageSource, 0, options as CFDictionary) {
            return UIImage(cgImage: thumbnailCGImage)
        }
        return nil
    }

}


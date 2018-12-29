//
//  ViewController.swift
//  CIDemo
//
//  Created by Yuki Yamamoto on 2018/12/28.
//

import UIKit
import CoreImage

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    private var originalImage: UIImage?
    
    struct Filter {
        let filterName: String
        var filterEffectValue: Any?
        var filterEffectValueName: String?
        
        init(filterName: String, filterEffectValue: Any?, filterEffectValueName: String?) {
            self.filterName = filterName
            self.filterEffectValue = filterEffectValue
            self.filterEffectValueName = filterEffectValueName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalImage = imageView.image
    }
    
    private func applyFilterTo(image: UIImage, filterEffect: Filter) -> UIImage? {
        
        guard let cgImage = image.cgImage,
            let openGLContext = EAGLContext(api: .openGLES3) else {
            return nil
        }
        
        let context = CIContext(eaglContext: openGLContext)
        
        let ciImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: filterEffect.filterName)
        
        let kelvin = Int(textField.text!)
        print("kelvin input: \(kelvin)")
        
        let rawFilter = CIFilter(imageData: image.pngData(), options: nil)
        rawFilter?.setValue(kelvin,
                            forKey: CIRAWFilterOption.neutralTemperature.rawValue)
        
        
//        filter?.setValue(ciImage, forKey: kCIInputImageKey)
//
//        if let filterEffectValue = filterEffect.filterEffectValue,
//            let filterEffectValueName = filterEffect.filterEffectValueName {
//
//            filter?.setValue(filterEffectValue, forKey: filterEffectValueName)
//
//            filter?.setValue(0.1, forKey: kCIInputBrightnessKey)
//            filter?.setValue(1, forKey: kCIInputContrastKey)
//
//        }
        
        var filteredImage: UIImage?
        if let output = rawFilter?.value(forKeyPath: kCIOutputImageKey) as? CIImage,
            let cgiImageResult = context.createCGImage(output, from: output.extent) {
            filteredImage = UIImage(cgImage: cgiImageResult)
        }
        
        return filteredImage
    
    }

    @IBAction func applyWhiteBalance(_ sender: Any) {
        print("apply whiteB")
        
        guard let image = imageView.image else {
            return
        }
        
        imageView.image = applyFilterTo(image: image, filterEffect: Filter(filterName: "CIColorControls", filterEffectValue: 1, filterEffectValueName: kCIInputSaturationKey))
    }
    
    
    @IBAction func resetAction(_ sender: Any) {
        print("Reseting")
        imageView.image = originalImage
    }
}


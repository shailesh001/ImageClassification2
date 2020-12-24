//
//  ViewController.swift
//  ImageClassification2
//
//  Created by Shailesh Patel on 18/12/2020.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController {

    @IBOutlet weak var classifyImageButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    private var inputImage: UIImage?
    var classification: String?
    
    private let classifier = VisionClassifier(mlmodel: BananaOrApple2().model)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        imageView.contentMode = .scaleAspectFill
        
        imageView.image = UIImage.placeholder
        
        classifier?.delegate = self
        refresh()
    }

    @IBAction func selectButtonPressed(_ sender: Any) {
        getPhoto()
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        // Add row to info.plist "Privacy - Camera Usage Description" : "Allows user to capture a photo or video to upload to their family circle"
        // Otherwise you'll get an terminal exception
        getPhoto(cameraSource: true)
    }
    
    @IBAction func classifyImageButtonPressed(_ sender: Any) {
        classifyImage()
    }
    
    func refresh() {
        if inputImage == nil {
            classLabel.text = "Pick or take a photo!"
            imageView.image = UIImage.placeholder
            classifyImageButton.disable()
        } else {
            imageView.image = inputImage
            
            if classification == nil {
                classLabel.text = "None"
                classifyImageButton.enable()
            } else {
                classLabel.text = classification
                classifyImageButton.disable()
            }
        }
    }
    
    private func classifyImage() {
//        classification = "FRUIT!"
//        refresh()
        if let classifier = self.classifier, let image = inputImage {
            classifier.classify(image)
            classifyImageButton.disable()
        }
    }
}

extension ViewController: UINavigationControllerDelegate, UIPickerViewDelegate, UIImagePickerControllerDelegate {
    private func getPhoto(cameraSource: Bool = false) {
        let photoSource: UIImagePickerController.SourceType
        photoSource = cameraSource ? .camera : .photoLibrary
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = photoSource
        imagePicker.mediaTypes = [kUTTypeImage as String]
        present(imagePicker, animated: true)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        inputImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        classification = nil
        picker.dismiss(animated: true)
        refresh()
        
        if inputImage == nil {
            summonAlertView(message: "Image was malformed.")
        }
    }
    
    func summonAlertView(message: String? = nil) {
        let alertController = UIAlertController(title: "Error", message: message ?? "Action could not be completed.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

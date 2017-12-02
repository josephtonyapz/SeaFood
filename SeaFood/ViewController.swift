//
//  ViewController.swift
//  SeaFood
//
//  Created by tony joseph on 12/1/17.
//  Copyright © 2017 devscripters. All rights reserved.
//

import UIKit
import Vision
import CoreML

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet var cameraImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        self.navigationItem.title = "welcome"
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
        cameraImageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else{
            fatalError("Couldnt covert to CI Image")
            }
            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image:CIImage){
        guard let model = try? VNCoreMLModel(for:Inceptionv3().model)else{
            fatalError("Loading CoreMl model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else{
            fatalError("Model failed to process image")
            }
            //print(results)
            if let firstResult = results.first{
                if firstResult.identifier.contains("hot dog"){
                self.navigationItem.title = "Hot Dog"
            }else{
                self.navigationItem.title = "Not Hot dog"
            }
            }
        }
        let handler = VNImageRequestHandler(ciImage:image)
        
        do{
            try handler.perform([request])
        }catch{
            print(error)
        }
        }
    }
    




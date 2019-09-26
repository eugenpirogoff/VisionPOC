//
//  ViewController.swift
//  VisionPOC
//
//  Created by Eugen on 26.09.19.
//  Copyright © 2019 Eugen Pirogoff. All rights reserved.
//

import UIKit
import SwiftyCam
import Vision

class ViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate {
    
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var recognizedTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let button = SwiftyCamButton(frame: captureButton.frame)
        button.delegate = self
        view.addSubview(button)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        
        var workingString = ""
        
        let textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                return
            }
            
            for observation in observations {
                observation.topCandidates(1).forEach { text in
                    workingString += text.string + "\n"
                }
            }
        }
        
        // please try to fill the screen with the number
        textRecognitionRequest.minimumTextHeight = 0.05
        textRecognitionRequest.usesLanguageCorrection = false
        
//        this might be useful. maybe centering the region of interes to a middle rect
//        textRecognitionRequest.regionOfInterest
        
        textRecognitionRequest.recognitionLevel = .accurate
        
        let requestHandler = VNImageRequestHandler(cgImage: photo.cgImage! , options: [:])
        
        do {
            try requestHandler.perform([textRecognitionRequest])
        } catch {
            print(error)
        }
        
        workingString += "\n\n"
        
        recognizedTextLabel.text = workingString
        recognizedTextLabel.setNeedsLayout()
        recognizedTextLabel.setNeedsDisplay()
    }
}

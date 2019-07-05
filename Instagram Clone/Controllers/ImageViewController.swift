//
//  ImageViewController.swift
//  Instagram Clone
//
//  Created by Saheb Singh Tuteja on 05/07/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import UIKit
import NotificationCenter

class ImageViewController: UIViewController{
    let notification = NotificationCenter()
    var fetchedImage : UIImage?
    @IBOutlet weak var originalImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalImage.image = fetchedImage
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        if recognizer.state == .ended{
            originalImage.center = self.view.center
        }
    }
    @IBAction func handlePinch(recognizer:UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
    }
        
    @IBAction func handleRotate(recognizer:UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }
    @IBAction func handleLongPress(recognizer : UILongPressGestureRecognizer) {
        recognizer.minimumPressDuration = TimeInterval(exactly: 3)!
        UIPasteboard.general.image = originalImage.image
        let alert = UIAlertController(title: "Copied To CLipboard", message: "", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        var time = 3
        while time >= 0 {
            time = time - 1
            if time == 0 {
                dismiss(animated: true, completion: nil)
                break
            }
        }
    }

}

//
//  AddPostViewController.swift
//  Instagram Clone
//
//  Created by Saheb Singh Tuteja on 01/07/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import UIKit
import Firebase
import Fabric

class AddPostViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let db = Firestore.firestore()
    var postedID = ""
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var shareNavigation: UINavigationBar!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Fabric.sharedSDK().debug = true
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.clipsToBounds = true
        uploadedImage.isHidden = true
        postTextView.layer.borderWidth = 1
        let url = Auth.auth().currentUser?.photoURL//(NSURL(string: UserDefaults.standard.object(forKey: "ImageData") as! String))! as URL
        print(type(of: url))
        if let data = try? Data(contentsOf: url!){
            if let image = UIImage(data: data){
                profilePicture.image = image
            }
        }
        userNameLabel.text = UserDefaults.standard.object(forKey: "Username") as? String
        
        // Do any additional setup after loading the view.
    }    
    
    @IBAction func shareAction(_ sender: Any) {
        let caption = postTextView.text
        var ref : DocumentReference? = nil
        ref = db.collection("posts").addDocument(data: [
            
            "postCaption" : "\(caption!)"
            
        ]) { err in
            
            if let err = err{
                print("Error documenting data \(err)")
            }
            else
            {

                print("Document added with ID: \(ref!.documentID)")
            }
            
        }
        Analytics.logEvent("caption_Posted", parameters: ["value":"\(caption!)"])
        postedID = ref!.documentID
        postTextView.text = ""
        let uploadRef = Storage.storage().reference(withPath: "posts/\(postedID).jpg")
        guard let imageData = uploadedImage.image?.jpegData(compressionQuality: 0.75) else { return }
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "uploads/jpeg"
        uploadRef.putData(imageData, metadata: uploadMetadata) { (uploadedMetadata, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            else
            {
                print(uploadedMetadata!)
            }
        }
        let alert = UIAlertController(title: "Post Uploaded", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        Analytics.logEvent("image_Posted", parameters: ["url" : "uploads/\(postedID).jpg"])
        uploadedImage.image = nil
    }
    @IBAction func addImagePicker(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
//            self.getImage(fromSourceType: .camera)
//        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //get image from source type
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadedImage.isHidden = false
        uploadedImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



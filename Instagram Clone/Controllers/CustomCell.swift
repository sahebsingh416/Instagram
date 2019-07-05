//
//  CustomCell.swift
//  Instagram Clone
//
//  Created by Saheb Singh Tuteja on 01/07/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import UIKit
import Firebase

class CustomCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var postedImage: UIImageView!
    @IBOutlet weak var likedByLabel: UILabel!
    @IBOutlet weak var postedProfileName: UILabel!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var alert = UIAlertController()
    var likeCount : Int = 0
    let db = Firestore.firestore()
    var deleteFlag : Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let url = Auth.auth().currentUser?.photoURL
        if let data = try? Data(contentsOf: url!){
            if let image = UIImage(data: data){
                profileImage.image = image
            }
        }
        profileName.text = Auth.auth().currentUser?.displayName
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        likeImage.isHidden = true
        // Configure the view for the selected state
    }
    
    @IBAction func likeButtonAction(_ sender: Any) {
        likeImage.isHidden.toggle()
        likeImage.isHidden == true ? (likeCount += 1) : (likeCount -= 1)
        likeImage.isHidden == true ? Analytics.logEvent("liked", parameters: ["Value" : 1]) : Analytics.logEvent("liked", parameters: ["value" : 0])
        likeCount <= 0 ? (likedByLabel.text = "Liked by 1 person") : (likedByLabel.text = "")
    }
    @IBAction func deleteAction(_ sender: UIButton) {
        db.collection("posts").getDocuments { (querySnapshots, err) in
            if let err = err {
                print(err.localizedDescription)
            } else {
                for document in querySnapshots!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    if document.data()["postCaption"] as? String == self.captionTextView.text
                    {
                        self.db.collection("posts").document(document.documentID).delete()
                    }
                }
            }
        }
    }
    
//    @IBAction func editAction(_ sender: UIButton) {
//        var textField = UITextField()
//        alert = UIAlertController(title: "Enter Data", message: "", preferredStyle: .alert)
//        alert.addTextField { (alertText) in
//            alertText.placeholder = "Enter New Data"
//            textField = alertText
//        }
//        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        alert.addAction(action)
//        captionTextView.text = textField.text
//
//    }
    
}

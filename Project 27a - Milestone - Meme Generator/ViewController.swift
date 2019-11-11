//
//  ViewController.swift
//  Project 27a - Milestone - Meme Generator
//
//  Created by Sean Williams on 11/11/2019.
//  Copyright © 2019 Sean Williams. All rights reserved.
//
import CoreGraphics
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var bottomLabel: UILabel!
    
    
    
    var memeTopText = ""
    var memeBottomText = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ac = UIAlertController(title: "Create Your Meme", message: "Please import a picture from your library...", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Select Picture", style: .default, handler: imagePicker(alert:)))
        present(ac, animated: true)
    }

    func imagePicker(alert: UIAlertAction) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    
    //MARK: - Image Picker Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //Picked image
        guard let image = info[.editedImage] as? UIImage else { return }
        
        imageView.image = image
        
        dismiss(animated: true)
        
        if imageView.image != nil {
            let ac = UIAlertController(title: "Top Meme Text", message: "If you wish, please eneter text for top of meme.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Leave Blank", style: .cancel))
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Add Text", style: .default, handler: { (action) in
                guard let text = ac.textFields?[0].text else { return }
                self.topLabel.text = text
                
                let ac2 = UIAlertController(title: "Bottom Meme Text", message: "If you wish, please eneter text for bottom of meme.", preferredStyle: .alert)
                ac2.addAction(UIAlertAction(title: "Leave Blank", style: .cancel))
                ac2.addTextField()
                ac2.addAction(UIAlertAction(title: "Add Text", style: .default, handler: { (action) in
                    guard let bottomText = ac2.textFields?[0].text else { return }
                    self.bottomLabel.text = bottomText
                }))
                
                self.present(ac2 , animated: true)
            }))
            
            present(ac, animated: true)
            

        }
    }
    
    
    //Core Graphics
    
    func addTextToMeme() {
        guard let size = imageView.image?.size else { return }
        
        let renderer = UIGraphicsImageRenderer(size: size)
        let img = renderer.image { ctx in
            
            
            let allignment = NSMutableParagraphStyle()
            allignment.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: "Chalkduster",
                .paragraphStyle: allignment
            ]
            
            let attributedString = NSAttributedString(string: memeTopText, attributes: attrs)
            attributedString.draw(with: CGRect(x: 0, y: 0, width: 200, height: 200), options: .usesLineFragmentOrigin, context: nil)
            
        }
        
    }
}


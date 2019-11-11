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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareMeme))
        
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
    
    
    @objc func shareMeme() {
        let ac = UIActivityViewController(activityItems: [generateMeme()!], applicationActivities: nil)
        present(ac, animated: true)
        imageView.image = generateMeme()
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
    
    func generateMeme() -> UIImage? {
        guard let image = imageView.image else { return nil}
        
        let renderer = UIGraphicsImageRenderer(size: image.size)
        let img = renderer.image { ctx in
//            guard let image = imageView.image else { return }
            
            image.draw(at: CGPoint(x: 0, y: 0))
            
            let allignment = NSMutableParagraphStyle()
            allignment.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 70),
                .strokeWidth: 10,
                .paragraphStyle: allignment,
                .foregroundColor: UIColor.white
            ]
            
//            ctx.cgContext.translateBy(x: image.size.width / 2, y: image.size.height / 2)
            
            let topAttributedString = NSAttributedString(string: topLabel.text ?? "", attributes: attrs)
            topAttributedString.draw(with: CGRect(x: 10, y: 30, width: image.size.width - 10, height: 200), options: .usesLineFragmentOrigin, context: nil)
            
            let bottomAttributedString = NSAttributedString(string: bottomLabel.text ?? "", attributes: attrs)
            bottomAttributedString.draw(with: CGRect(x: 10, y: image.size.height - 100, width: image.size.width - 10, height: 200), options: .usesLineFragmentOrigin, context: nil)
            
        }
        return img
    }
}


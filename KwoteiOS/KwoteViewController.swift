//
//  ViewController.swift
//  KwoteiOS
//
//  Created by Joshua Holmes on 4/10/2016.
//  Copyright © 2016 Joshua Holmes. All rights reserved.
//

import UIKit
import RealmSwift

class KwoteViewController: UIViewController {
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    var imageView: UIImageView?
    var overlay: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadQuote()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.quoteLabel.layer.borderColor = UIColor.white.cgColor
        self.quoteLabel.layer.borderWidth = 1
    }
    
    @IBAction func refreshButtonPressed(_ sender: AnyObject) {
        self.loadQuote()
    }
    
    @IBAction func settingsButtonPressed(_ sender: AnyObject) {
        print("Settings button pressed")
    }
    
    func setBackgroundImage(image: UIImage) {
        guard let resizedImage = image.resize(height: UIScreen.main.bounds.height) else {
            NSLog("Failed to resize image")
            return
        }
        
        let frame = CGRect(x: -(resizedImage.size.width / 2), y: 0, width: resizedImage.size.width, height: resizedImage.size.height)
        let newImageView = UIImageView(frame: frame)
        newImageView.image = resizedImage
        
        if let imageView = self.imageView {
            UIView.transition(with: self.view, duration: 1.0, options: .transitionCrossDissolve, animations: {
                self.view.insertSubview(newImageView, aboveSubview: imageView)
            }, completion: { (success) in
                self.imageView = newImageView
                imageView.removeFromSuperview()
            })
            return
        } else {
            self.imageView = newImageView
        }
        
        // Apply darkened overlay
        let overlay = UIView(frame: UIScreen.main.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.overlay = overlay
        
        self.view.insertSubview(newImageView, at: 0)
        self.view.insertSubview(overlay, at: 1)
        
        newImageView.alpha = 0
        overlay.alpha = 0
        
        UIView.animate(withDuration: 1.0) {
            newImageView.alpha = 1
            overlay.alpha = 1
        }
    }
    
    func removeBackgroundImage() {
        NSLog("Removing background image")
        
        guard let imageView = self.imageView, let overlay = self.overlay else {
            return
        }
        
        self.imageView = nil
        self.overlay = nil
        
        UIView.animate(withDuration: 1.0, animations: {
            imageView.alpha = 0
            overlay.alpha = 0
        }) { (success) in
            imageView.removeFromSuperview()
            overlay.removeFromSuperview()
        }
    }
    
    func loadQuote() {
        KwoteFactory.getKwote(category: .Movies) { kwote in
            if let kwote = kwote {
                MovieDBAPI.getMovieBackdropImage(movieName: kwote.author) { (image) in
                    
                    self.quoteLabel.text = kwote.quote
                    self.authorLabel.text = kwote.author
                    
                    if let image = image {
                        self.setBackgroundImage(image: image)
                    } else {
                        self.removeBackgroundImage()
                    }
                }
            } else {
                self.presentError(message: "Failed to load a new Kwote. Make sure you're connected to the interwebs.")
            }
        }
    }
    
    func presentError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


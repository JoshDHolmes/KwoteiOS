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
    @IBOutlet weak var loaderIcon: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIButton!
    
    var imageView: UIImageView?
    var overlay: UIView?
    var settingsView: UIView?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadQuote()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.quoteLabel.layer.borderColor = UIColor.white.cgColor
        self.quoteLabel.layer.borderWidth = 1
        self.loaderIcon.contentScaleFactor = 1.5
    }
    
    @IBAction func refreshButtonPressed(_ sender: AnyObject) {
        self.loadQuote()
    }
    
    @IBAction func settingsButtonPressed(_ sender: AnyObject) {
        print("Settings button pressed")
        self.showSettings()
    }
    
    @IBAction func shareButtonPressed(_ sender: AnyObject) {
        guard let quoteText = self.quoteLabel.text, let authorText = self.authorLabel.text else {
            return
        }
        
        let message = "\"\(quoteText)\" - \(authorText)"
        var activityItems: [Any] = [message]
        
        if let image = self.imageView?.image {
            activityItems.append(image)
        }
        
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityVC, animated: true) { 
            //
        }
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
        self.refreshButton.isHidden = true
        self.loaderIcon.isHidden = false
        
        KwoteFactory.getKwote(category: .Movies) { kwote in
            if let kwote = kwote {
                NSLog("Quote: \(kwote.quote)")
                NSLog("Author: \(kwote.author)")
                MovieDBAPI.getMovieBackdropImage(movieName: kwote.author) { (image) in
                    self.refreshButton.isHidden = false
                    self.loaderIcon.isHidden = true
                    self.quoteLabel.text = kwote.quote
                    self.authorLabel.text = kwote.author
                    self.quoteLabel.isHidden = false
                    
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
    
    func showSettings() {
        //let frame = UIScreen.main.bounds
        //let settingsView = UIView(frame: frame)
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        
        visualEffectView.frame = UIScreen.main.bounds
        visualEffectView.alpha = 0
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeSettings)))
        self.settingsView = visualEffectView
        self.view.addSubview(visualEffectView)
        
        UIView.animate(withDuration: 0.3) {
            visualEffectView.alpha = 1
        }
        
        let sm = UISegmentedControl()
        sm.frame.size.height = 50
        sm.frame.size.width = UIScreen.main.bounds.width - 50
        
        visualEffectView.addSubview(sm)
    }
    
    func closeSettings() {
        print("close settings pressed")
        guard let settingsView = self.settingsView else {
            return
        }
        
        settingsView.removeFromSuperview()
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


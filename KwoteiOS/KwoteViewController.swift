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
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadQuote()
    }
    
    @IBAction func newKwoteButtonPressed(_ sender: AnyObject) {
        self.loadQuote()
    }
    
    func selectedCategory() -> Category {
        var category: Category
        
        switch self.categorySegmentedControl.selectedSegmentIndex {
        case 0:
            category = .Famous
        case 1:
            category = .Movies
        case 2:
            category = .Inspire
        case 3:
            category = .Management
        case 4:
            category = .Funny
        default:
            category = .Famous
        }
        
        return category
    }
    
    func loadQuote() {
        KwoteFactory.getKwote(category: .Famous) { kwote in
            if let kwote = kwote {
                self.quoteLabel.text = kwote.quote
                self.authorLabel.text = kwote.author
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


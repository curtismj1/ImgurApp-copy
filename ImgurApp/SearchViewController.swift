//
//  SearchViewController.swift
//  ImgurApp
//
//  Created by Michael on 4/26/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, searchResultsDelegate{
    
    var images = [image]()
    
    @IBOutlet weak var searchField: UITextField!
    
    func doSegue(notification: NSNotification){
        println("dosegue")
        self.performSegueWithIdentifier("segue", sender: self)
    }
    
    
    func done(child: searchResults){
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func searchButton(sender: UIButton) {
        var searchToken = searchField.text
        
        searchToken = searchToken.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        searchField.resignFirstResponder()
        
        var url = "https://api.imgur.com/3/gallery/t/"
        var finalUrl = url + searchToken
        
        var queue = NSOperationQueue()
        
        queue.name = "download"
        
        var op = myOp(url: finalUrl)
        
        queue.addOperation(op)
        
        op.completionBlock = {
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.view.backgroundColor = UIColor.greenColor()
                
                println("completion block")
                self.images = op.images
                
                NSNotificationCenter.defaultCenter().postNotificationName("segue", object: nil)
   
            })
        }
    }
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "doSegue:", name:"segue", object: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let child = segue.destinationViewController as! searchResults
        
        child.images = self.images
        child.delegate = self
        
    }
}

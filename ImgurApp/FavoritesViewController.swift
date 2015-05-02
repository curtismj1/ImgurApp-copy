//
//  FavoritesViewController.swift
//  ImgurApp
//
//  Created by Michael Kytka on 4/16/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    var favorites = Favorites()
    var images:Array<String> = []
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var next: UIButton!
    @IBOutlet weak var previous: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        favorites.loadImagesFromFile()
        images = favorites.getImages()
        if(images.count > 0){
            var url = NSURL(string: images[0])
            var request = NSURLRequest(URL: url!)
            webView.loadRequest(request)
            
        }

        
    }
    
    var currentIndex = 0
    
    @IBAction func nextImage(sender: AnyObject) {
        if (currentIndex < images.count - 1) {
            currentIndex++
            var url = NSURL(string: images[currentIndex])
            var request = NSURLRequest(URL: url!)
            webView.loadRequest(request)
        }
    }
    
    
    @IBAction func previousImage(sender: AnyObject) {
        if (currentIndex > 0) {
            currentIndex--
            var url = NSURL(string: images[currentIndex])
            var request = NSURLRequest(URL: url!)
            webView.loadRequest(request)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
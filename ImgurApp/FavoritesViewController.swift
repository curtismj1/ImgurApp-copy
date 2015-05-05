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
    var currentIndex = 0
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        favorites.loadImagesFromFile()
        images = favorites.getImages()
        if(images.count > 0){
            var url = NSURL(string: images[0])
            var request = NSURLRequest(URL: url!)
            webView.loadRequest(request)
            
        }
    }
    
    @IBAction func clearFavs(sender: AnyObject) {
        favorites.clearAll()
        favorites.saveImages()
        favorites.loadImagesFromFile()
        images = favorites.getImages()

    }
    
    
    
    @IBAction func deleteFav(sender: AnyObject) {
        
        if(images.count == 1){
            favorites.clearAll()
            favorites.saveImages()
            favorites.loadImagesFromFile()
            images = favorites.getImages()
        }
        else if(currentIndex < images.count){
        favorites.delete(images[currentIndex])
        favorites.saveImages()
        favorites.loadImagesFromFile()
        images = favorites.getImages()
            if(currentIndex < images.count){
                var url = NSURL(string: images[currentIndex])
                var request = NSURLRequest(URL: url!)
                webView.loadRequest(request)
            }

        }

    }
    
    func addToFavorites() {
        for image in favorites.images{
            if(images.count > 0){
                if (image == images[currentIndex]){
                    return
                }
                favorites.add(images[currentIndex])
                favorites.saveImages()
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*favorites.loadImagesFromFile()
        images = favorites.getImages()
        if(images.count > 0){
            var url = NSURL(string: images[0])
            var request = NSURLRequest(URL: url!)
            webView.loadRequest(request)
            
        }
        */
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "didSwipe:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "didSwipe:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        

        
    }
    @IBAction func didSwipe(sender: UISwipeGestureRecognizer) {
        if(sender.direction == UISwipeGestureRecognizerDirection.Right){
            previousImage()
        }
        else{
            nextImage()
        }
    }
    
   
    
    @IBAction func nextImage() {
        if (currentIndex < images.count - 1) {
            currentIndex++
            var url = NSURL(string: images[currentIndex])
            var request = NSURLRequest(URL: url!)
            webView.loadRequest(request)
        }
    }
    
    
    @IBAction func previousImage() {
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

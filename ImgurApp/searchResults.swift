//
//  searchResults.swift
//  ImgurApp
//
//  Created by Michael on 4/27/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

import UIKit

protocol searchResultsDelegate{
    func done(child: searchResults)
}

class searchResults: UIViewController {
    
    var currentIndex = 0
    var delegate: searchResultsDelegate!
    var favorites = Favorites()
    
    @IBOutlet weak var web: UIWebView!
    
    var images = [image]()
    var str_images:Array<String> = []
    
    override func viewDidLoad() {
        var url = NSURL(string: images.first!.link as String)
        var request = NSURLRequest(URL: url!)
        web.loadRequest(request)
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "didSwipe:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "didSwipe:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: "didDoubleTap:")
        doubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGesture)
    }
    
    @IBAction func done(sender: AnyObject) {
        delegate.done(self)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        favorites.loadImagesFromFile()
        str_images = favorites.getImages()
    }

    @IBAction func didSwipe(sender: UISwipeGestureRecognizer) {
        if(sender.direction == UISwipeGestureRecognizerDirection.Right){
            previousImage();
        }
        else{
            nextImage();
        }
    }
    @IBAction func addToFavs(sender: AnyObject) {
        favorites.add(images[currentIndex].link as String)
        favorites.saveImages()
        sendNotificationFavorite()
    }
    func nextImage() {
        if (currentIndex < images.count - 1) {
            currentIndex++
            var url = NSURL(string: images[currentIndex].link as String)
            var request = NSURLRequest(URL: url!)
            web.loadRequest(request)
        }
    }
    
    func sendNotificationFavorite(){
        //println("notification")
        var localNotification: UILocalNotification = UILocalNotification()
        localNotification.alertAction = "Favorite Save"
        localNotification.alertBody = "favorite successful!"
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 10)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    func previousImage() {
        if (currentIndex > 0) {
            currentIndex--
            var url = NSURL(string: images[currentIndex].link as String)
            var request = NSURLRequest(URL: url!)
            web.loadRequest(request)
        }
    }
    
    @IBAction func randomRequest(sender: UIButton) {
        currentIndex = random() % images.count
        var url = NSURL(string: images[currentIndex].link as String)
        var request = NSURLRequest(URL: url!)
        web.loadRequest(request)
        
    }
    @IBAction func favoriteImage(sender: UIButton) {
        favorites.add(images[currentIndex].link as String)
        favorites.saveImages()
        sendNotificationFavorite()
    }
}

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
    }
    
    @IBAction func done(sender: AnyObject) {
        delegate.done(self)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        favorites.loadImagesFromFile()
        str_images = favorites.getImages()
    }

    @IBAction func addToFavs(sender: AnyObject) {
        
    }
    @IBAction func nextImage(sender: UIButton) {
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
    
    @IBAction func prevImage(sender: UIButton) {
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

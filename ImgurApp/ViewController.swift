//
//  ViewController.swift
//  ImgurApp
//
//  Created by Michael on 4/14/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

import UIKit
import Foundation



class ViewController: UIViewController, NSURLSessionDelegate{
    var urlString = "https:api.imgur.com/3/gallery.json"
    var images:Array<String> = []
    var favorites = Favorites()
    @IBOutlet weak var webView: UIWebView!
    let layer = CALayer()
    

    var currentIndex = 0
    
    @IBOutlet weak var imgView: UIImageView!
    func nextImage() {
        if (currentIndex < images.count) {
            currentIndex++
            var url = NSURL(string: images[currentIndex])
            var request = NSURLRequest(URL: url!)
            webView.loadRequest(request)
        }
    }
    
    @IBAction func didSwipe(sender: UISwipeGestureRecognizer) {
        if(sender.direction == UISwipeGestureRecognizerDirection.Right){
            previousImage();
        }
        else{
            nextImage();
        }
     
        
    }
   
  
    func previousImage() {
        if (currentIndex > 0) {
            currentIndex--
            var url = NSURL(string: images[currentIndex])
            var request = NSURLRequest(URL: url!)
            webView.loadRequest(request)
        }
    }
    
    @IBAction func didDoubleTap(sender: UITapGestureRecognizer) {
        addToFavorites()
        showHeart()
    }
    
    @IBAction func randomImage(sender: AnyObject) {
        if images.count != 0{
            currentIndex = random() % images.count
            var url = NSURL(string: images[currentIndex])
            var request = NSURLRequest(URL: url!)
            webView.loadRequest(request)
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
                sendNotificationFavorite()
                
            }
        }

    }
    @IBOutlet weak var favoriteImage: UIButton!
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset: Int64, expectedTotalBytes: Int64) {
        //NSLog("Downloaded: \(didResumeAtOffset) of \(expectedTotalBytes) bytes")
    }
    
    func sendNotificationFavorite(){
        //println("notification")
        var localNotification: UILocalNotification = UILocalNotification()
        localNotification.alertAction = "Favorite Save"
        localNotification.alertBody = "favorite successful!"
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 10)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData: Int64,  totalBytesWritten: Int64, expectedTotalBytes: Int64) {
       // NSLog("Downloaded: \(totalBytesWritten) of \(expectedTotalBytes) bytes")
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location : NSURL) {
        
        let jsonData = NSData(contentsOfURL: location)
        let json : Dictionary = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.AllowFragments, error: NSErrorPointer()) as! Dictionary<String, AnyObject>
        
        //let dataitem = swiftyJSON["data"].string!
        
        let arr:NSArray = json["data"] as! NSArray
        let dictionary:NSDictionary = arr[0] as! NSDictionary
        
        //println(dictionary)
        
        
        for pics in arr{
            let pic_dic = pics as! NSDictionary
            images.append(pic_dic["link"] as! String)
        }
        for item in images{
            //NSLog(item)
        }
    }
    func showHeart(){
        var x:CGFloat = 0.0
        UIView.animateWithDuration(1.2, delay: 0.0, options: .BeginFromCurrentState,
            animations:
            {
            self.imgView.hidden = false
            self.imgView.alpha = x
            x+=0.01
  
            },
            completion: {(value: Bool) in
        
        })
  
        
        
    }
    func loadGallery(completion: ((AnyObject) -> Void)!){
        
        
        let str = NSString(contentsOfURL: NSURL(string: "https://api.imgur.com/3/gallery.json")!, encoding: NSUTF8StringEncoding, error: nil)
        var jsonData = NSData(contentsOfURL: NSURL(string: "https://api.imgur.com/3/gallery.json")!)

        let str2 = NSString(contentsOfURL: NSURL(string: "https://api.imgur.com/3/gallery/hot/viral/0.json")!, encoding: NSUTF8StringEncoding, error: nil)
        var jsonData2 = NSData(contentsOfURL: NSURL(string: "https://api.imgur.com/3/gallery/hot/viral/0.json")!)
        
        let str3 = NSString(contentsOfURL: NSURL(string: "https://api.imgur.com/3/memegen/defaults.json")!, encoding: NSUTF8StringEncoding, error: nil)
        var jsonData3 = NSData(contentsOfURL: NSURL(string: "https://api.imgur.com/3/memegen/defaults.json")!)
        
        
        
        
        //let str = "http://api.kivaws.org/v1/loans/newest.json"
        let url = NSURL(string: urlString)
        
        //let jsonData = NSData(contentsOfURL: url!)
        let json : Dictionary = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.AllowFragments, error: NSErrorPointer()) as! Dictionary<String, AnyObject>
        
        
       /*let urlArray : Dictionary = json["data"] as! Dictionary<String, String>
        for (key, value) in urlArray{
            NSLog(value)
            /*for (key, value) in url{
                NSLog(value)
            }*/
        }*/
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.HTTPAdditionalHeaders = ["Authorization" : "Client-ID a90cdde824df9ea"]
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        let dTask = session.downloadTaskWithURL(url!)
        
        dTask.resume();
    
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGallery(nil)
        var url = NSURL(string: "www.google.com")
        var request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "didSwipe:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "didSwipe:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: "didDoubleTap:")
        doubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGesture)
        
        
        //load current favorites
        favorites.loadImagesFromFile()
        
        //var anObserver = MyObserver(object: favorites);

        
        //Heart stuff
        let img = UIImage(named: "heart.png")
        imgView.image = img;
        view.addSubview(imgView)
        imgView.hidden = true
        
 
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


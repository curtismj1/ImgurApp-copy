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

    
    var currentIndex = 0
    
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
    
    
    @IBAction func randomImage(sender: AnyObject) {
        currentIndex = random() % images.count
        var url = NSURL(string: images[currentIndex])
        var request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
    
    func addToFavorites(sender: AnyObject) {
        favorites.add(images[currentIndex])
        favorites.saveImages()
        sendNotificationFavorite()
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
        
        //var anObserver = MyObserver(object: favorites);
 
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


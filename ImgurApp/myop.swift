//
//  MyOp.swift
//  Exam 2 Key
//
//  Created by Michael Kytka on 4/21/15.
//  Copyright (c) 2015 Default. All rights reserved.
//

import Foundation
import UIKit


class myOp: NSOperation, NSURLSessionDelegate{
    var url: String!
    
    var shouldKeepRunning = true
    
    var images = [image]()
    
    init(url: String){
        super.init()
        self.url = url
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData: Int64,  totalBytesWritten: Int64, expectedTotalBytes: Int64) {
        // NSLog("Downloaded: \(totalBytesWritten) of \(expectedTotalBytes) bytes")
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location : NSURL) {
        
        let jsonData = NSData(contentsOfURL: location)
        let json : Dictionary = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.AllowFragments, error: NSErrorPointer()) as! Dictionary<String, AnyObject>
        

        
        if let jData = json["data"] as? Dictionary<String, AnyObject>{
            if let items = jData["items"] as? [AnyObject]{
                for item in items{
                    var i = item as? Dictionary<String, AnyObject>
                    var theItem = i!
                    var link : NSString!
                    var description : NSString!
                    var title : NSString!
                    if let theLink = theItem["link"] as? NSString{
                        link = theItem["link"]! as! NSString
                    }
                    else{ link = ""}
                    if let theDescription = theItem["description"] as? NSString{
                        description = theItem["description"]! as! NSString
                    }
                    else{ description = ""}
                    if let theTitle = theItem["title"] as? NSString{
                        title = theItem["title"]! as! NSString
                    }
                    else{ title = ""}
                    var newImage = image(li: link, de: description, ti: title)
                    images.append(newImage)
                }
            }
        }
        
        shouldKeepRunning = false
        
    }
    
    
    
    
    override func main() {
        if self.cancelled{
            return
        }
        
        
        let url = NSURL(string: self.url!)
        
        var jsonData = NSData(contentsOfURL: NSURL(string: self.url!)!)
        
        let json : Dictionary = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.AllowFragments, error: NSErrorPointer()) as! Dictionary<String, AnyObject>
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.HTTPAdditionalHeaders = ["Authorization" : "Client-ID a90cdde824df9ea"]
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)

        
        let task = session.downloadTaskWithURL(url!);
        
        
        
        task.resume();
        
        while shouldKeepRunning {
        }
     
    }
    
}
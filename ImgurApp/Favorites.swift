//
//  Favorites.swift
//  ImgurApp
//
//  Created by Michael on 4/15/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

import Foundation


class Favorites{
    init() {}
    var images:Array<String> = []
    var fileManager = NSFileManager.defaultManager()
    let file = "favorites.rtf"
    var path = ""
    func saveImages(){
        var giantImageString = ""
        for image in images{
            giantImageString = giantImageString + image + "\n"
            
        }
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String] {
                let dir = dirs[0] //documents directory
                path = dir.stringByAppendingPathComponent(file);
                
            
                //writing
                giantImageString.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil);
                
                //reading
                let text2 = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
        }
    }
    func add(myImage:String){
        images.append(myImage)
    }
    func clearAllFavorites(){
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String] {
            let dir = dirs[0] //documents directory
            path = dir.stringByAppendingPathComponent(file);
            
            let text = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
            let lines : Array<String> = text!.componentsSeparatedByString("\n")
            let blank = ""
            
            for line in lines{
                images.append(line)
            }
            
        }

        
    }
    func getImages() ->Array<String>{
        return images
    }
    func loadImagesFromFile(){
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String] {
            let dir = dirs[0] //documents directory
            path = dir.stringByAppendingPathComponent(file);
            let text = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
            if(text != nil){
                let lines : Array<String> = text!.componentsSeparatedByString("\n")
                
                for line in lines{
                    if (line != ""){
                        images.append(line)
                    }
                }
            }

        }


    }
}
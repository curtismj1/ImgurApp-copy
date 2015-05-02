//
//  images.swift
//  ImgurApp
//
//  Created by Michael on 4/26/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

import Foundation

class image{
    var link : NSString!
    var description : NSString!
    var title : NSString!
    init(li : NSString, de : NSString, ti : NSString!){
        self.link = li
        self.description = de
        self.title = ti
    }
}

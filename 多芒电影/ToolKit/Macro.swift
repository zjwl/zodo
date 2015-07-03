//
//  Macro.swift
//  PinterestSwift
//
//  Created by Nicholas Tau on 7/1/14.
//  Copyright (c) 2014 Nicholas Tau. All rights reserved.
//

import Foundation
import UIKit

let screenBounds = UIScreen.mainScreen().bounds
let screenSize   = screenBounds.size
let screenWidth  = screenSize.width
let screenHeight = screenSize.height
let gridWidth : CGFloat = 155.0
let navigationHeight : CGFloat = 44.0
let statubarHeight : CGFloat = 20.0
let navigationHeaderAndStatusbarHeight : CGFloat = navigationHeight + statubarHeight


var IS_IPHONE = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone)
var IS_RETINA = UIScreen.mainScreen().scale>=2.0

var SCREEN_MAX_LENGTH = (max(screenWidth, screenHeight))
var SCREEN_MIN_LENGTH = (min(screenWidth, screenHeight))

var IS_IPHONE_4_OR_LESS = (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
var IS_IPHONE_5 = (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
var IS_IPHONE_6 = (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
var IS_IPHONE_6P = (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


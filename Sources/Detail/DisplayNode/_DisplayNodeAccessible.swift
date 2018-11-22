//
//  _DisplayNodeAccessible.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/11/10.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation

@objc
internal protocol _DisplayNodeAccessible: AnyObject {
  
  var displayNode: DisplayNode? { get set }
  
}

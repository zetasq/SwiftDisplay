//
//  CALayerExtendedDelegate.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/11/10.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation
import UIKit

/**
 * Optional methods that the view associated with an _ASDisplayLayer can implement.
 * This is distinguished from _ASDisplayLayerDelegate in that it points to the _view_
 * not the node. Unfortunately this is required by ASCollectionView, since we currently
 * can't guarantee that an ASCollectionNode exists for it.
 */
@objc
internal protocol CALayerExtendedDelegate: AnyObject {
  
  @objc
  optional func layer(_ layer: CALayer, didChangeBoundsWithOldValue oldBounds: CGRect, newValue newBounds: CGRect)
  
}

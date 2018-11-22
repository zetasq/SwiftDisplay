//
//  DisplayNodeFlags.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/11/10.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation

internal struct DisplayNodeFlags {
  
  internal static let visibilityNotificationsDisabledBits = 4
  
  // MARK: - public properties
  var viewEverHadAGestureRecognizerAttached = false
  var layerBacked = false
  var displaysAsynchronously = false
  var rasterizesSubtree = false
  var shouldBypassEnsureDisplay = false
  var displaySuspended = false
  var shouldAnimateSizeChanges = false
  
  // Wrapped view handling
  
  // The layer contents should not be cleared in case the node is wrapping a UIImageView.UIImageView is specifically
  // optimized for performance and does not use the usual way to provide the contents of the CALayer via the
  // CALayerDelegate method that backs the UIImageView.
  var canClearContentsOfLayer = false
  
  // Prevent calling setNeedsDisplay on a layer that backs a UIImageView. Usually calling setNeedsDisplay on a CALayer
  // triggers a recreation of the contents of layer unfortunately calling it on a CALayer that backs a UIImageView
  // it goes through the normal flow to assign the contents to a layer via the CALayerDelegate methods. Unfortunately
  // UIImageView does not do recreate the layer contents the usual way, it actually does not implement some of the
  // methods at all instead it throws away the contents of the layer and nothing will show up.
  var canCallSetNeedsDisplayOfLayer = false
  
  var implementsDrawRect = false
  var implementsImageDisplay = false
  var implementsDrawParameters = false
  
  // internal state
  var isEnteringHierarchy = false
  var isExitingHierarchy = false
  var isInHierarchy = false
  var visibilityNotificationsDisabled: Int = 0
  
  var isDeallocating = false
  
}

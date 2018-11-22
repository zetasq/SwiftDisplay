//
//  _DisplayLayerDelegate.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/11/10.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation
import UIKit

/**
 Implement one of +displayAsyncLayer:parameters:isCancelled: or +drawRect:withParameters:isCancelled: to provide drawing for your node.
 Use -drawParametersForAsyncLayer: to copy any properties that are involved in drawing into an immutable object for use on the display queue.
 display/drawRect implementations MUST be thread-safe, as they can be called on the displayQueue (async) or the main thread (sync/displayImmediately)
 */
@objc
internal protocol _DisplayLayerDelegate: AnyObject {
  
  // Called on the display queue and/or main queue (MUST BE THREAD SAFE)
  
  /**
   @summary Delegate method to draw layer contents into a CGBitmapContext. The current UIGraphics context will be set to an appropriate context.
   @param parameters An object describing all of the properties you need to draw. Return this from -drawParametersForAsyncLayer:
   @param isCancelledBlock Execute this block to check whether the current drawing operation has been cancelled to avoid unnecessary work. A return value of YES means cancel drawing and return.
   @param isRasterizing YES if the layer is being rasterized into another layer, in which case drawRect: probably wants to avoid doing things like filling its bounds with a zero-alpha color to clear the backing store.
   */
  @objc
  optional static func drawRect(_ bounds: CGRect, parameters: Any?, isCanceledBlock: () -> Bool, isRasterizing: Bool)
  
  /**
   @summary Delegate override to provide new layer contents as a UIImage.
   @param parameters An object describing all of the properties you need to draw. Return this from -drawParametersForAsyncLayer:
   @param isCancelledBlock Execute this block to check whether the current drawing operation has been cancelled to avoid unnecessary work. A return value of YES means cancel drawing and return.
   @return A UIImage with contents that are ready to display on the main thread. Make sure that the image is already decoded before returning it here.
   */
  @objc
  optional static func display(withParameters parameters: Any?, isCanceledBlock: () -> Bool) -> UIImage
  
  // Called on the main thread only
  
  /**
   @summary Delegate override for drawParameters
   */
  @objc
  optional func drawParameters(forAsyncLayer layer: _DisplayLayer) -> Any?
  
  /**
   @summary Delegate override for willDisplay
   */
  @objc
  optional func willDisplayAsyncLayer(_ layer: _DisplayLayer, asynchronously: Bool)
  
  /**
   @summary Delegate override for didDisplay
   */
  @objc
  optional func didDisplayAsyncLayer(_ layer: _DisplayLayer)
  
  /**
   @summary Delegate callback to display a layer, synchronously or asynchronously.  'asyncLayer' does not necessarily need to exist (can be nil).  Typically, a delegate will display/draw its own contents and then set .contents on the layer when finished.
   */
  @objc
  optional func displayAsyncLayer(_ asyncLayer: _DisplayLayer, asynchronously: Bool)
  
  /**
   @summary Delegate callback to handle a layer which requests its asynchronous display be cancelled.
   */
  @objc
  optional func cancelDisplayAsyncLayer(_ asyncLayer: _DisplayLayer)
}

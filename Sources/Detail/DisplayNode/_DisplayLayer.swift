//
//  _DisplayLayer.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/11/10.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import UIKit

internal final class _DisplayLayer: CALayer {
  
  // MARK: - Public properties
  
  /**
   @discussion This property overrides the CALayer category method which implements this via associated objects.
   This should result in much better performance for _ASDisplayLayers.
   */
  internal override var displayNode: DisplayNode? {
    get {
      return _displayNode
    }
    set {
      _displayNode = newValue
    }
  }
  
  private weak var _displayNode: DisplayNode?
  
  /**
   @summary Delegate for asynchronous display of the layer. This should be the node (default) unless you REALLY know what you're doing.
   
   @desc The asyncDelegate will have the opportunity to override the methods related to async display.
   */
  internal let asyncDelegate: AtomicWeak<_DisplayLayerDelegate> = .init(value: nil)
  
  
  
  /**
   @summary Set to YES to enable asynchronous display for the receiver.
   
   @default YES (note that this might change for subclasses)
   */
  internal var displaysAsynchronously: Bool {
    get {
      return (self.value(forKey: #function) as? Bool) ?? true
    }
    set {
      self.setValue(newValue, forKey: #function)
    }
  }
  
  /**
   @summary Suspends both asynchronous and synchronous display of the receiver if YES.
   
   @desc This can be used to suspend all display calls while the receiver is still in the view hierarchy.  If you
   want to just cancel pending async display, use cancelAsyncDisplay instead.
   
   @default NO
   */
  internal var isDisplaySuspended: Bool = false {
    didSet {
      DisplayNodeAssertMainThread()
      
      guard isDisplaySuspended != oldValue else {
        return
      }
      
      if !displaysAsynchronously {
        // If resuming display, trigger a display now.
        setNeedsDisplay()
      } else {
        // If suspending display, cancel any current async display so that we don't have contents set on us when it's finished.
        cancelAsyncDisplay()
      }
    }
  }
  
  // MARK: - Private properties
  private var _attemptedDisplayWhileZeroSized: Bool = false
  
  // MARK: - Public methods
  /**
   @summary Cancels any pending async display.
   
   @desc If the receiver has had display called and is waiting for the dispatched async display to be executed, this will
   cancel that dispatched async display.  This method is useful to call when removing the receiver from the window.
   */
  internal func cancelAsyncDisplay() {
    DisplayNodeAssertMainThread()
    
    asyncDelegate.value?.cancelDisplayAsyncLayer?(self)
  }
  
  /**
   @summary Bypasses asynchronous rendering and performs a blocking display immediately on the current thread.
   
   @desc Used by ASDisplayNode to display the layer synchronously on-demand (must be called on the main thread).
   */
  internal func displayImmediately() {
    // This method is a low-level bypass that avoids touching CA, including any reset of the
    // needsDisplay flag, until the .contents property is set with the result.
    // It is designed to be able to block the thread of any caller and fully execute the display.
    DisplayNodeAssertMainThread()
    
    _display(asynchronously: false)
  }
  
  // MARK: - Key-value coding
  override class func defaultValue(forKey key: String) -> Any? {
    if key == "opaque" {
      return true
    }
    
    return super.defaultValue(forKey: key)
  }
  
  // MARK: - CAlayer overrides
  override var bounds: CGRect {
    didSet {
      assert(bounds.isValidForLayout, "Caught attempt to set invalid bounds \(bounds) on \(self)")
      
      displayNode?.threadSafeBounds = bounds
      
      (delegate as? CALayerExtendedDelegate)?.layer?(self, didChangeBoundsWithOldValue: oldValue, newValue: bounds)
      
      if _attemptedDisplayWhileZeroSized && !bounds.isEmpty && !needsDisplayOnBoundsChange {
        _attemptedDisplayWhileZeroSized = false
        setNeedsDisplay()
      }
    }
  }
  
  #if DEBUG
  
  // These override is strictly to help detect application-level threading errors.  Avoid method overhead in release.
  override var contents: Any? {
    didSet {
      DisplayNodeAssertMainThread()
    }
  }
  
  override func setNeedsLayout() {
    super.setNeedsLayout()
    
    DisplayNodeAssertMainThread()
  }
  
  #endif
  
  override func layoutSublayers() {
    DisplayNodeAssertMainThread()
    
    super.layoutSublayers()
    
    displayNode?.__layout()
  }
  
  override func setNeedsDisplay() {
    DisplayNodeAssertMainThread()
    
    // FIXME: Reconsider whether we should cancel a display in progress.
    // We should definitely cancel a display that is scheduled, but unstarted display.
    cancelAsyncDisplay()
    
    // Short circuit if display is suspended. When resumed, we will setNeedsDisplay at that time.
    if !isDisplaySuspended {
      super.setNeedsDisplay()
    }
  }
  
  
  override func display() {
    DisplayNodeAssertMainThread()
    
    _hackResetNeedsDisplay()
    
    guard !isDisplaySuspended else {
      return
    }
    
    _display(asynchronously: displaysAsynchronously)
  }
  
  // MARK: - CustomStringConvertible
  override var description: String {
    var text = super.description
    
    if let node = displayNode {
      text += "\(node)"
    }
    
    return text
  }
  // MARK: - Helper methods
  private func _display(asynchronously: Bool) {
    if bounds.isEmpty {
      _attemptedDisplayWhileZeroSized = true
    }
    
    asyncDelegate.value?.displayAsyncLayer?(self, asynchronously: asynchronously)
  }
  
  private func _hackResetNeedsDisplay() {
    DisplayNodeAssertMainThread()
    
    // Don't listen to our subclasses crazy ideas about setContents by going through super
    super.contents = super.contents
  }
  
  

}

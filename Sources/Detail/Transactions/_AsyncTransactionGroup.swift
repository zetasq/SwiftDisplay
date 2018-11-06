//
//  _AsyncTransactionGroup.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/10/30.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation

/// A group of transaction containers, for which the current transactions are committed together at the end of the next runloop tick.
internal final class _AsyncTransactionGroup {
  
  private static let _mainTransactionGroup: _AsyncTransactionGroup = {
    let transactionGroup = _AsyncTransactionGroup()
    
    transactionGroup.registerAsMainRunloopObserver()
    
    return transactionGroup
  }()
  
  /// The main transaction group is scheduled to commit on every tick of the main runloop.
  /// Access from the main thread only.
  internal static var main: _AsyncTransactionGroup {
    DisplayNodeAssertMainThread()
    return _mainTransactionGroup
  }
  
  private let _containers = NSHashTable<_AsyncTransactionContainer>(options: .objectPointerPersonality)
  
  private init() {}
  
  /// Add a transaction container to be committed.
  internal func addTransactionContainer(_ container: _AsyncTransactionContainer) {
    DisplayNodeAssertMainThread()
    _containers.add(container)
  }
  
  internal func commit() {
    DisplayNodeAssertMainThread()
    
    guard _containers.count > 0 else {
      return
    }
    
    let containersToCommit = _containers.allObjects
    _containers.removeAllObjects()
    
    for container in containersToCommit {
      // Note that the act of committing a transaction may open a new transaction,
      // so we must nil out the transaction we're committing first.
      let transaction = container.currentAsyncTransaction
      container.currentAsyncTransaction = nil
      transaction?.commit()
    }
  }
  
  private func registerAsMainRunloopObserver() {
    DisplayNodeAssertMainThread()
    
    // defer the commit of the transaction so we can add more during the current runloop iteration
    
    let activities: CFRunLoopActivity = [.beforeWaiting, .exit]
    
    let observer = CFRunLoopObserverCreateWithHandler(nil, activities.rawValue, true, CFIndex.max) { (observer, activity) in
      self.commit()
    }
    
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, .commonModes)
  }

}

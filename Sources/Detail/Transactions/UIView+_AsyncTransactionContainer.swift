//
//  UIView+_AsyncTransactionContainer.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/10/30.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation
import UIKit

extension UIView: _AsyncTransactionContainer {
  var isAsyncTransactionContainer: Bool {
    get {
      return self.layer.isAsyncTransactionContainer
    }
    set {
      self.layer.isAsyncTransactionContainer = newValue
    }
  }
  
  var asyncTransactionContainerState: _AsyncTransactionContainerState {
    return self.layer.asyncTransactionContainerState
  }
  
  func cancelAsyncTransactions() {
    self.layer.cancelAsyncTransactions()
  }
  
  var currentAsyncTransaction: _AsyncTransaction? {
    get {
      return self.layer.currentAsyncTransaction
    }
    set {
      self.layer.currentAsyncTransaction = newValue
    }
  }
  
  
}

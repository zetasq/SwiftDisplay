//
//  _AsyncTransactionOperation.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/10/29.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation


  internal final class _AsyncTransactionOperation: CustomStringConvertible {
    
    internal private(set) var operationCompletion: _AsyncTransaction.OperationCompletionBlock?
    
    internal let result: Atomic<Any?> = .init(value: nil) // set on bg queue by the operation block
    
    internal init(operationCompletion: _AsyncTransaction.OperationCompletionBlock?) {
      self.operationCompletion = operationCompletion
    }
    
    deinit {
      assert(operationCompletion == nil, "_AsyncTransaction.callAndReleaseCompletionBlock should be called before deinit")
    }
    
    internal func callAndReleaseCompletionBlock(canceled: Bool) {
      DisplayNodeAssertMainThread()
      
      operationCompletion?(result.value, canceled)
      // Guarantee that _operationCompletionBlock is released on main thread
      operationCompletion = nil
    }
    
    var description: String {
      return "_AsyncTransaction.Operation: \(self) - value = \(result.value ?? NSNull())"
    }
    
    
    
  }

//
//  _AsyncTransactionQueuePool.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/11/6.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation

internal enum _AsyncTransactionQueuePool {
  
  private static let _transactionQueues: [DispatchQueue] = {
    var queues: [DispatchQueue] = []
    
    for i in 0..<ProcessInfo.processInfo.activeProcessorCount {
      let queue = DispatchQueue(
        label: "com.zetasq.SwiftDisplay._AsyncTransactionQueuePool.transactionExecutionQueue-\(i)",
        target: .global(qos: .userInitiated)
      )
      
      queues.append(queue)
    }
    
    return queues
  }()
  
  internal static func randomQueue() -> DispatchQueue {
    return _transactionQueues.randomElement()!
  }
  
}

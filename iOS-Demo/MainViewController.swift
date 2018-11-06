//
//  MainViewController.swift
//  SwiftDisplay-iOS-Demo
//
//  Created by Zhu Shengqi on 2018/11/4.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let group = DispatchGroup()
    
    group.enter()
    DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
      group.leave()
    }
    
    group.notify(queue: .global()) {
      print("group finished")
    }
    
    group.wait()
    print("wait finished")
  }


}


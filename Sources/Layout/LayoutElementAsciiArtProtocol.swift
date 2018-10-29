//
//  LayoutElementAsciiArtProtocol.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/4/7.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation
import CoreGraphics

protocol LayoutElementAsciiArtProtocol {
  
  /**
   *  Returns an ascii-art representation of this object and its children.
   *  For example, an ASInsetSpec may return something like this:
   *
   *   --ASInsetLayoutSpec--
   *   |     ASTextNode    |
   *   ---------------------
   */
  var asciiArtString: String { get }
  
  /**
   *  returns the name of this object that will display in the ascii art. Usually this can
   *  simply be NSStringFromClass([self class]).
   */
  var asciiArtName: String { get }
  
}

final class AsciiArtBoxCreator {

  private static let debugBoxPadding = 2
  
  /**
   *  Renders an ascii art box with the children aligned horizontally
   *  Example:
   *  ------------ASStackLayoutSpec-----------
   *  |  ASTextNode  ASTextNode  ASTextNode  |
   *  ----------------------------------------
   */
  static func horizontalBoxString(forChildren children: [String], parent: String) -> String {
    guard !children.isEmpty else {
      return parent
    }
    
    var childrenLines: [[String]] = []
    
    // split the children into lines
    var lineCountPerChild = 0
    for child in children {
      let lines = child.components(separatedBy: "\n")
      lineCountPerChild = max(lineCountPerChild, lines.count)
    }
    
    for child in children {
      var lines = child.components(separatedBy: "\n")
      let topPadding = Int(ceil(CGFloat(lineCountPerChild - lines.count) / 2.0))
      let bottomPadding = (lineCountPerChild - lines.count) / 2
      let lineLength = lines[0].count
      
      for _ in 0..<topPadding {
        lines.insert(String(repeating: " ", count: lineLength), at: 0)
      }
      
      for _ in 0..<bottomPadding {
        lines.append(String(repeating: " ", count: lineLength))
      }
      childrenLines.append(lines)
    }
    
    var concatenatedLines: [String] = []
    let padding = String(repeating: " ", count: AsciiArtBoxCreator.debugBoxPadding)
    
    for index in 0..<lineCountPerChild {
      var line = ""
      line += "|" + padding
      for childLines in childrenLines {
        line += childLines[index] + padding
      }
      line += "|"
      concatenatedLines.append(line)
    }
    
    // surround the lines in a box
    let totalLineLength = concatenatedLines[0].count
    if totalLineLength < parent.count {
      let difference = parent.count + 2 * AsciiArtBoxCreator.debugBoxPadding - totalLineLength
      let leftPadding = Int(ceil(CGFloat(difference) / 2.0))
      let rightPadding = difference / 2
      
      let leftString = "|" + String(repeating: " ", count: leftPadding)
      let rightString = String(repeating: " ", count: rightPadding) + "|"
      
      var paddedLines: [String] = []
      for line in concatenatedLines {
        var paddedLine = line.replacingOccurrences(of: "|", with: leftString, options: .caseInsensitive, range: line.startIndex..<line.index(line.startIndex, offsetBy: 1))
        paddedLine = paddedLine.replacingOccurrences(of: "|", with: rightString, options: .caseInsensitive, range: line.index(line.endIndex, offsetBy: -1)..<line.endIndex)
        paddedLines.append(paddedLine)
      }
      concatenatedLines = paddedLines
    }
    
    concatenatedLines = self.appendTopAndBottom(toBoxStrings: concatenatedLines, parent: parent)
    return concatenatedLines.joined(separator: "\n")
  }
  
  /**
   *  Renders an ascii art box with the children aligned vertically.
   *  Example:
   *   --ASStackLayoutSpec--
   *   |     ASTextNode    |
   *   |     ASTextNode    |
   *   |     ASTextNode    |
   *   ---------------------
   */
  static func verticalBoxString(forChildren children: [String], parent: String) -> String {
    guard !children.isEmpty else {
      return parent
    }
    
    var childrenLines: [String] = []
    
    var maxChildLength = 0
    for child in children {
      let lines = child.components(separatedBy: "\n")
      maxChildLength = max(maxChildLength, lines[0].count)
    }
    
    var rightPadding = 0
    var leftPadding = 0
    
    if maxChildLength < parent.count {
      let difference = parent.count + 2 * AsciiArtBoxCreator.debugBoxPadding - maxChildLength
      leftPadding = Int(ceil(CGFloat(difference) / 2.0))
      rightPadding = difference / 2
    }
    
    let rightPaddingString = String(repeating: " ", count: rightPadding + AsciiArtBoxCreator.debugBoxPadding)
    let leftPaddingString = String(repeating: " ", count: leftPadding + AsciiArtBoxCreator.debugBoxPadding)
    
    for child in children {
      var lines = child.components(separatedBy: "\n")
      
      let leftLinePadding = Int(ceil(CGFloat(maxChildLength - lines[0].count) / 2.0))
      let rightLinePadding = (maxChildLength - lines[0].count) / 2
      
      for line in lines {
        let rightLinePaddingString = String(repeating: " ", count: rightLinePadding) + rightPaddingString + "|"
        
        let leftLinePaddingString = "|" + String(repeating: " ", count: leftLinePadding) + leftPaddingString
        
        let paddingLine = leftLinePaddingString + line + rightLinePaddingString
        childrenLines.append(paddingLine)
      }
    }
    
    childrenLines = self.appendTopAndBottom(toBoxStrings: childrenLines, parent: parent)
    return childrenLines.joined(separator: "\n")
  }
  
  private static func appendTopAndBottom(toBoxStrings boxStrings: [String], parent: String) -> [String] {
    let totalLineLength = boxStrings[0].count
    var result = boxStrings
    result.append(String(repeating: "-", count: totalLineLength))
    
    let leftPadding = Int(ceil(CGFloat(totalLineLength - parent.count) / 2.0))
    let rightPadding = (totalLineLength - parent.count) / 2
    
    let topLine = String(repeating: "-", count: leftPadding) + parent + String(repeating: "-", count: rightPadding)
    result.insert(topLine, at: 0)
    
    return result
  }
}

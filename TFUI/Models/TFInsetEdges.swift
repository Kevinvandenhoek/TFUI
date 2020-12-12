//
//  TFInsetEdges.swift
//  TFUI
//
//  Created by Kevin van den Hoek on 12/12/2020.
//

public struct TFInsetEdges: OptionSet {
    
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public extension TFInsetEdges {
    
    static let left = TFInsetEdges(rawValue: 1 << 0)
    static let top = TFInsetEdges(rawValue: 1 << 1)
    static let right = TFInsetEdges(rawValue: 1 << 2)
    static let bottom = TFInsetEdges(rawValue: 1 << 3)
    
    static let all: TFInsetEdges = [.left, .top, .right, .bottom]
    static let none: TFInsetEdges = []
}

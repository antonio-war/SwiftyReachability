//
//  SwiftyRadioType.swift
//  
//
//  Created by AntonioWar on 02/09/22.
//

import Foundation

public enum SwiftyRadioType: CustomStringConvertible {
    case undefined
    case _2G
    case _3G
    case _4G
    case _5G
    
    public var description: String {
        switch self {
        case .undefined:
            return "?"
        case ._2G:
            return "2G"
        case ._3G:
            return "3G"
        case ._4G:
            return "4G"
        case ._5G:
            return "5G"
        }
    }
}

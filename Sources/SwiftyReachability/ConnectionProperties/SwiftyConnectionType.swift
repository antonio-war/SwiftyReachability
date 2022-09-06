//
//  SwiftyConnectionType.swift
//  
//
//  Created by AntonioWar on 02/09/22.
//

import Foundation

public enum SwiftyConnectionType : Equatable, CustomStringConvertible {
    case cellular(radioType: SwiftyRadioType)
    case wifi
    case ethernet
    
    public var description: String {
        switch self {
        case .cellular(let radioType):
            return "Cellular(" + radioType.description + ")"
        case .wifi:
            return "WiFi"
        case .ethernet:
            return "Ethernet"
        }
    }
}

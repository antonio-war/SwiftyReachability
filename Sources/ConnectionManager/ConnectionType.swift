//
//  ConnectionType.swift
//  
//
//  Created by AntonioWar on 02/09/22.
//

import Foundation

public enum ConnectionType : Equatable, CustomStringConvertible {
    case cellular(radioType: RadioType)
    case wifi
    case ethernet
    
    public var description: String {
        switch self {
        case .cellular(let radioType):
            switch radioType {
            case .undefined:
                return "Cellular<?>"
            case ._2G:
                return "Cellular<2G>"
            case ._3G:
                return "Cellular<3G>"
            case ._4G:
                return "Cellular<4G>"
            case ._5G:
                return "Cellular<5G>"
            }
        case .wifi:
            return "WiFi"
        case .ethernet:
            return "Ethernet"
        }
    }
}

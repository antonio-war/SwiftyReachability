//
//  ConnectionType.swift
//  
//
//  Created by AntonioWar on 02/09/22.
//

import Foundation

public enum ConnectionType : Equatable {
    case cellular(radioType: RadioType)
    case wifi
    case ethernet
}

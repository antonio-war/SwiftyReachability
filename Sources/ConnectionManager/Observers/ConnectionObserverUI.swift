//
//  ConnectionObserverUI.swift
//  
//
//  Created by AntonioWar on 03/09/22.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
class ConnectionObserverUI: ObservableObject, ConnectionObserver {
    
    @Published
    var connectionStatus: ConnectionStatus
    
    @Published
    var connectionType: ConnectionType?
    
    init() {
        self.connectionStatus = .offline
        self.connectionType = .none
        startObserving()
    }
    
    deinit {
        stopObserving()
    }
    
    func didChangeConnectionStatus(_ status: ConnectionStatus) {
        self.connectionStatus = connectionStatus
    }
    
    func didChangeConnectionType(_ type: ConnectionType?) {
        self.connectionType = connectionType
    }
}

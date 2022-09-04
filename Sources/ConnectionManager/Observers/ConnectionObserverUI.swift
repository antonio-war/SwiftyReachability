//
//  ConnectionObserverUI.swift
//  
//
//  Created by AntonioWar on 03/09/22.
//

import Foundation

@available(iOS 13.0, *)
public class ConnectionObserverUI: ObservableObject, ConnectionObserver {
    
    public var observerId: UUID = UUID()
    
    @Published
    public var connectionStatus: ConnectionStatus
    
    @Published
    public var connectionType: ConnectionType?
    
    public init() {
        self.connectionStatus = .offline
        self.connectionType = .none
        startObserving()
    }
    
    deinit {
        stopObserving()
    }
    
    public func didChangeConnectionStatus(_ status: ConnectionStatus) {
        DispatchQueue.main.async {
            self.connectionStatus = status
        }
    }
    
    public func didChangeConnectionType(_ type: ConnectionType?) {
        DispatchQueue.main.async {
            self.connectionType = type
        }
    }
}

//
//  ConnectionObserver.swift
//  
//
//  Created by AntonioWar on 02/09/22.
//

import Foundation

public protocol ConnectionObserver {
    func startObserving()
    func stopObserving()
    func didChangeConnectionStatus(_ status: ConnectionStatus)
    func didChangeConnectionType(_ type: ConnectionType?)
}

public extension ConnectionObserver {
    internal var connectionObserverId : String {
        get {
            return String(unsafeBitCast(self, to: Int.self))
        }
    }
    
    func startObserving() {
        ConnectionManager.shared.addObserver(observer: self)
    }
    
    func stopObserving() {
        ConnectionManager.shared.removeObserver(observer: self)
    }
}

//
//  SwiftyReachabilityObserver.swift
//  
//
//  Created by AntonioWar on 02/09/22.
//

import Foundation

public protocol SwiftyReachabilityObserver {
    func startObserving()
    func stopObserving()
    func didChangeConnectionStatus(_ status: SwiftyConnectionStatus)
    func didChangeConnectionType(_ type: SwiftyConnectionType?)
}

public extension SwiftyReachabilityObserver {
    internal var connectionObserverId : String {
        get {
            return String(unsafeBitCast(self, to: Int.self))
        }
    }
    
    func startObserving() {
        SwiftyReachability.shared.addObserver(observer: self)
    }
    
    func stopObserving() {
        SwiftyReachability.shared.removeObserver(observer: self)
    }
}

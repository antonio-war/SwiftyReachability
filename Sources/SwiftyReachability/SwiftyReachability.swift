//
//  SwiftyReachability.swift
//
//
//  Created by AntonioWar on 02/09/22.
//

import Network
import CoreTelephony

public class SwiftyReachability {
    
    public static var shared : SwiftyReachability = SwiftyReachability()
    
    private let monitor : NWPathMonitor
    
    private var semaphore : DispatchSemaphore? = DispatchSemaphore(value: 0)
    
    public var connectionStatus: SwiftyConnectionStatus {
        didSet {
            for observer in observers.values {
                observer.didChangeConnectionStatus(connectionStatus)
            }
        }
    }
    
    public var connectionType: SwiftyConnectionType? {
        didSet {
            for observer in observers.values {
                observer.didChangeConnectionType(connectionType)
            }
        }
    }
    
    private var observers : [String: SwiftyReachabilityObserver]
    
    private init() {
        connectionStatus = .offline
        connectionType = .none
        observers = [:]
        monitor = NWPathMonitor.init()
        
        monitor.pathUpdateHandler = { path in
            self.setConnection(path: path)
        }
        
        monitor.start(queue: DispatchQueue.global(qos: .background))
        
        semaphore?.wait()
        semaphore = nil
    }
    
    private func setConnection(path: NWPath) {
        var newConnectionStatus : SwiftyConnectionStatus = .offline
        var newConnectionType : SwiftyConnectionType? = nil
        
        guard path.status == .satisfied else {
            newConnectionStatus = .offline
            newConnectionType = .none
            if self.connectionStatus != newConnectionStatus {
                self.connectionStatus = newConnectionStatus
            }
            if self.connectionType != newConnectionType {
                self.connectionType = newConnectionType
            }
            semaphore?.signal()
            return
        }
        
        newConnectionStatus = .online
        
        if path.usesInterfaceType(.cellular) {
            let networkInfo = CTTelephonyNetworkInfo()
            guard let currentRadio = networkInfo.serviceCurrentRadioAccessTechnology?.values.first else {
                newConnectionType = .cellular(radioType: .undefined)
                return
            }
            switch currentRadio {
            case CTRadioAccessTechnologyGPRS, CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyCDMA1x:
                newConnectionType = .cellular(radioType: ._2G)
            case CTRadioAccessTechnologyWCDMA, CTRadioAccessTechnologyHSDPA, CTRadioAccessTechnologyHSUPA, CTRadioAccessTechnologyCDMAEVDORev0, CTRadioAccessTechnologyCDMAEVDORevA, CTRadioAccessTechnologyCDMAEVDORevB, CTRadioAccessTechnologyeHRPD:
                newConnectionType = .cellular(radioType: ._3G)
            case CTRadioAccessTechnologyLTE:
                newConnectionType = .cellular(radioType: ._4G)
            default:
                if #available(iOS 14.1, *) {
                    switch currentRadio {
                    case CTRadioAccessTechnologyNRNSA, CTRadioAccessTechnologyNR:
                        newConnectionType = .cellular(radioType: ._5G)
                    default:
                        newConnectionType = .cellular(radioType: .undefined)
                    }
                } else {
                    newConnectionType = .cellular(radioType: .undefined)
                }
            }
        } else if path.usesInterfaceType(.wifi) {
            newConnectionType = .wifi
        } else if path.usesInterfaceType(.wiredEthernet) {
            newConnectionType = .ethernet
        }
        
        if self.connectionStatus != newConnectionStatus {
            self.connectionStatus = newConnectionStatus
        }
        
        if self.connectionType != newConnectionType {
            self.connectionType = newConnectionType
        }
        semaphore?.signal()
    }
    
    internal func addObserver(observer: SwiftyReachabilityObserver) {
        observer.didChangeConnectionStatus(connectionStatus)
        observer.didChangeConnectionType(connectionType)
        observers[observer.connectionObserverId] = observer
    }
    
    internal func removeObserver(observer: SwiftyReachabilityObserver) {
        observers[observer.connectionObserverId] = nil
    }
    
    deinit {
        monitor.cancel()
    }
}

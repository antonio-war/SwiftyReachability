//
//  ConnectionManager.swift
//
//
//  Created by AntonioWar on 02/09/22.
//

import Network
import CoreTelephony

public class ConnectionManager {
    
    public static var shared : ConnectionManager = ConnectionManager()
    
    private let monitor : NWPathMonitor
    
    private var semaphore : DispatchSemaphore? = DispatchSemaphore(value: 0)
    
    public var connectionType: ConnectionType? {
        didSet {
            semaphore?.signal()
        }
    }
    
    public var isConnected: Bool {
        return connectionType != nil
    }
    
    private init() {
        monitor = NWPathMonitor.init()
        
        monitor.pathUpdateHandler = { path in
            self.setConnection(path: path)
        }
        
        monitor.start(queue: DispatchQueue.global(qos: .background))
        
        semaphore?.wait()
        semaphore = nil
    }
    
    private func setConnection(path: NWPath) {
        var newConnectionType : ConnectionType? = nil
        
        guard path.status == .satisfied else {
            newConnectionType = .none
            if self.connectionType != newConnectionType {
                self.connectionType = newConnectionType
            }
            return
        }
        
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
        
        if self.connectionType != newConnectionType {
            self.connectionType = newConnectionType
        }
    }
    
    deinit {
        monitor.cancel()
    }
}

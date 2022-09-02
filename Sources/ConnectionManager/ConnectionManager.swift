//
//  ConnectionManager.swift
//
//
//  Created by AntonioWar on 02/09/22.
//

import Network

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
    
    deinit {
        monitor.cancel()
    }
    
    private func setConnection(path: NWPath) {
        guard path.status == .satisfied else {
            if self.connectionType != .none {
                self.connectionType = .none
            }
            return
        }
        
        if path.usesInterfaceType(.cellular) {
            if self.connectionType != .cellular {
                self.connectionType = .cellular
            }
        } else if path.usesInterfaceType(.wifi) {
            if self.connectionType != .wifi {
                self.connectionType = .wifi
            }
        } else if path.usesInterfaceType(.wiredEthernet) {
            if self.connectionType != .ethernet {
                self.connectionType = .ethernet
            }
        }
    }
}

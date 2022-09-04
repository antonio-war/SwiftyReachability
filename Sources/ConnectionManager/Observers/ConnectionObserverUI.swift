//
//  ConnectionObserverUI.swift
//  
//
//  Created by AntonioWar on 03/09/22.
//

import Foundation

@available(iOS 13.0, *)
public class ConnectionObserverUI: ObservableObject {
    
    @Published
    public var connectionStatus: ConnectionStatus
    
    @Published
    public var connectionType: ConnectionType?
    
    private var hiddenObserver: HiddenObserver
    
    public init() {
        self.hiddenObserver = HiddenObserver()
        self.connectionStatus = .offline
        self.connectionType = .none
        self.hiddenObserver.setExternalObserver(observer: self)
    }
    
    class HiddenObserver : ConnectionObserver {
        weak var externalObserver: ConnectionObserverUI?
        
        var observerId: UUID = UUID()
        
        init() {
            startObserving()
        }
        
        func setExternalObserver(observer: ConnectionObserverUI) {
            self.externalObserver = observer
        }
        
        deinit {
            stopObserving()
        }
        
        public func didChangeConnectionStatus(_ status: ConnectionStatus) {
            DispatchQueue.main.async {
                self.externalObserver?.connectionStatus = status
            }
        }
        
        public func didChangeConnectionType(_ type: ConnectionType?) {
            DispatchQueue.main.async {
                self.externalObserver?.connectionType = type
            }
        }
    }
}

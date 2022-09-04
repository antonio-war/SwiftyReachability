//
//  SwiftyReachabilityObserverUI.swift
//  
//
//  Created by AntonioWar on 03/09/22.
//

import Foundation

@available(iOS 13.0, *)
public class SwiftyReachabilityObserverUI: ObservableObject {
    
    @Published
    public var connectionStatus: SwiftyConnectionStatus
    
    @Published
    public var connectionType: SwiftyConnectionType?
    
    private var hiddenObserver: HiddenObserver
    
    public init() {
        self.hiddenObserver = HiddenObserver()
        self.connectionStatus = .offline
        self.connectionType = .none
        self.hiddenObserver.setExternalObserver(observer: self)
    }
    
    class HiddenObserver : SwiftyReachabilityObserver {
        weak var externalObserver: SwiftyReachabilityObserverUI?
        
        init() {
            startObserving()
        }
        
        func setExternalObserver(observer: SwiftyReachabilityObserverUI) {
            self.externalObserver = observer
        }
        
        deinit {
            stopObserving()
        }
        
        public func didChangeConnectionStatus(_ status: SwiftyConnectionStatus) {
            DispatchQueue.main.async {
                self.externalObserver?.connectionStatus = status
            }
        }
        
        public func didChangeConnectionType(_ type: SwiftyConnectionType?) {
            DispatchQueue.main.async {
                self.externalObserver?.connectionType = type
            }
        }
    }
}

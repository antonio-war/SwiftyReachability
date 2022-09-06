<p align="center">
<img width="1042" alt="Schermata 2022-09-06 alle 10 04 08" src="https://user-images.githubusercontent.com/59933379/188581267-2457d49c-119f-4109-9573-b1069c40ad37.png">
</p>

SwiftyReachability is a simple and lightweight network interface manager written in Swift.

Freely inspired by https://github.com/tonymillion/Reachability, with the aim of providing an updated interface that includes all the innovations introduced in the iOS world since its latest update and add new features.

- **Easy to use:** no configuration needed, SwiftyReachability is ready to go.
- **Shared:** it's based on a single istance shared by the whole app, you can access to the network layer's information at any time and any point.
- **Detailed:** it allows you to know the connection type used and in the case of 'Cellular Network' you also know which radio technology is being used.
- **SwiftUI compatible:** provides an elegant SwiftUI support that is very easy to use.
- **Multiple Observers:** you can define several network Observers at the same time to get information and update your UI.

---

# Installation

You can use Swift Package Manager to add SwiftyReachability to your project.

## Add Package Dependency

In Xcode, select File > Add Packages...

## Specify the Repository

Copy and paste the following into the search/input box.

https://github.com/antonio-war/SwiftyReachability

## Specify options

Use **Up to Next Major Version** as dependency rule and enter the current SwiftyReachability version.
Then click **Add Package**.

---

# Overview

## Connection Status

SwiftyReachability's main purpose is to track device connectivity. Through **SwiftyConnectionStatus** it is possible to find out if it is online or offline.

```swift
enum SwiftyConnectionStatus {
    case online
    case offline
}
```

## Connection Type

When the device is online it may be useful to know information about the connection type. You can do it through **SwiftyConnectionType**.

```swift
enum SwiftyConnectionType {
    case cellular(radioType: SwiftyRadioType)
    case wifi
    case ethernet
}
```
## Radio Type

Unlike original Reachability framework we introduced other information, when the device is connected to a cellular network you can know if it is using a 3G, LT or some other radio type, through **SwiftyRadioType**.

```swift
enum SwiftyRadioType {
    case undefined
    case _2G
    case _3G
    case _4G
    case _5G
}
```
On some devices, however, this feature is not available, at least for now.

---

# Simple Usage

In case you need to access current information, without the need to be informed about future changes, it's possibile to do so by directly accessing to the shared instance of SwiftyReachability.

```swift
let connectionManager = SwiftyReachability.shared
let status = connectionManager.connectionStatus
let type = connectionManager.connectionType      
```
---

# Observer Usage

When the status of your app needs to be updated based on the connection status you may need an observer. Obviously SwiftyReachability provides all the elements for this type of implementation.

<p align="center">
<img src="https://user-images.githubusercontent.com/59933379/188596659-347dd5e7-3a8b-45dc-9e06-19c3bc716280.gif" width="200" />
</p>

## Swift / UIKit

For simple objects or view created with UIKit we provide a protocol oriented solution. The object must conform to the **SwiftyReachabilityObserver** protocol and implement the required methods.
He also has to decide when to start and stop the observation.

```swift
class UIKitViewController: UIViewController, SwiftyReachabilityObserver {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var connectionTypeImage: UIImageView!
    @IBOutlet weak var radioTypeLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startObserving()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopObserving()
    }
    
    func didChangeConnectionStatus(_ status: SwiftyConnectionStatus) {
        DispatchQueue.main.async {
            switch status {
                case .online:
                self.statusLabel.text = "Online"
                self.statusLabel.backgroundColor = .systemGreen
                case .offline:
                self.statusLabel.text = "Offline"
                self.statusLabel.backgroundColor = .systemRed
            }
        }
    }
    
    func didChangeConnectionType(_ type: SwiftyConnectionType?) {
        DispatchQueue.main.async {
            guard let connectionType = type else {
                self.connectionTypeImage.isHidden = true
                self.radioTypeLabel.isHidden = true
                return
            }
            
            switch connectionType {
            case .cellular(let radioType):
                self.connectionTypeImage.image = UIImage(systemName: "antenna.radiowaves.left.and.right")
                self.connectionTypeImage.isHidden = false
                self.radioTypeLabel.text = radioType.description
                self.radioTypeLabel.isHidden = false
            case .wifi:
                self.connectionTypeImage.image = UIImage(systemName: "wifi")
                self.connectionTypeImage.isHidden = false
                self.radioTypeLabel.isHidden = true
            case .ethernet:
                self.connectionTypeImage.image = UIImage(systemName: "cable.connector")
                self.connectionTypeImage.isHidden = false
                self.radioTypeLabel.isHidden = true
            }
        }
    }
}
```

## SwiftUI

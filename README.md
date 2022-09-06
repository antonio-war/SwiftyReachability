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

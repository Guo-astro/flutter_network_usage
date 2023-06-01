import Flutter
import UIKit

public class SwiftNetworkUsagePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "network_usage", binaryMessenger: registrar.messenger())
        let instance = SwiftNetworkUsagePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getNetworkUsage":
            DispatchQueue.main.async {
                self.handleDataUsage(result: result)
            }
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        default:
            result(FlutterMethodNotImplemented)
        }
        
    }
    private func handleDataUsage(result: FlutterResult) {
        var data = [String: Any?]()
        data.updateValue(SystemDataUsage.wifiCompelete, forKey: "wifiCompelete")
        data.updateValue(SystemDataUsage.wifiReceived, forKey: "wifiReceived")
        data.updateValue(SystemDataUsage.wifiSent, forKey: "wifiSent")
        data.updateValue(SystemDataUsage.wwanCompelete, forKey: "wwanCompelete")
        data.updateValue(SystemDataUsage.wwanReceived, forKey: "wwanReceived")
        data.updateValue(SystemDataUsage.wwanSent, forKey: "wwanSent")
        result(data)
    }
    
    
    
}
extension SystemDataUsage {
    
    public static var wifiCompelete: NSNumber {
        return  NSNumber(value:SystemDataUsage.getDataUsage().wifiSent + SystemDataUsage.getDataUsage().wifiReceived)
    }
    
    public static var wifiSent: NSNumber {
        return NSNumber(value:SystemDataUsage.getDataUsage().wifiSent)
    }
    
    public static var wifiReceived: NSNumber {
        return NSNumber(value: SystemDataUsage.getDataUsage().wifiReceived)
    }
    
    public static var wwanCompelete: NSNumber {
        return NSNumber(value:  SystemDataUsage.getDataUsage().wirelessWanDataSent + SystemDataUsage.getDataUsage().wirelessWanDataReceived)
    }
    
    public static var wwanSent: NSNumber {
        return  NSNumber(value:SystemDataUsage.getDataUsage().wirelessWanDataSent)
    }
    
    public static var wwanReceived: NSNumber {
        return  NSNumber(value:SystemDataUsage.getDataUsage().wirelessWanDataReceived)
    }
    
}

class SystemDataUsage {
    
    private static let wwanInterfacePrefix = "pdp_ip"
    private static let wifiInterfacePrefix = "en"
    
    class func getDataUsage() -> DataUsageInfo {
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        var dataUsageInfo = DataUsageInfo()
        
        guard getifaddrs(&ifaddr) == 0 else { return dataUsageInfo }
        while let addr = ifaddr {
            guard let info = getDataUsageInfo(from: addr) else {
                ifaddr = addr.pointee.ifa_next
                continue
            }
            dataUsageInfo.updateInfoByAdding(info)
            ifaddr = addr.pointee.ifa_next
        }
        
        freeifaddrs(ifaddr)
        
        return dataUsageInfo
    }
    
    private class func getDataUsageInfo(from infoPointer: UnsafeMutablePointer<ifaddrs>) -> DataUsageInfo? {
        let pointer = infoPointer
        let name: String! = String(cString: pointer.pointee.ifa_name)
        let addr = pointer.pointee.ifa_addr.pointee
        guard addr.sa_family == UInt8(AF_LINK) else { return nil }
        
        return dataUsageInfo(from: pointer, name: name)
    }
    
    private class func dataUsageInfo(from pointer: UnsafeMutablePointer<ifaddrs>, name: String) -> DataUsageInfo {
        var networkData: UnsafeMutablePointer<if_data>?
        var dataUsageInfo = DataUsageInfo()
        
        if name.hasPrefix(wifiInterfacePrefix) {
            networkData = unsafeBitCast(pointer.pointee.ifa_data, to: UnsafeMutablePointer<if_data>.self)
            if let data = networkData {
                dataUsageInfo.wifiSent += UInt64(data.pointee.ifi_obytes)
                dataUsageInfo.wifiReceived += UInt64(data.pointee.ifi_ibytes)
            }
            
        } else if name.hasPrefix(wwanInterfacePrefix) {
            networkData = unsafeBitCast(pointer.pointee.ifa_data, to: UnsafeMutablePointer<if_data>.self)
            if let data = networkData {
                dataUsageInfo.wirelessWanDataSent += UInt64(data.pointee.ifi_obytes)
                dataUsageInfo.wirelessWanDataReceived += UInt64(data.pointee.ifi_ibytes)
            }
        }
        return dataUsageInfo
    }
}

struct DataUsageInfo {
    var wifiReceived: UInt64 = 0
    var wifiSent: UInt64 = 0
    var wirelessWanDataReceived: UInt64 = 0
    var wirelessWanDataSent: UInt64 = 0
    
    mutating func updateInfoByAdding(_ info: DataUsageInfo) {
        wifiSent += info.wifiSent
        wifiReceived += info.wifiReceived
        wirelessWanDataSent += info.wirelessWanDataSent
        wirelessWanDataReceived += info.wirelessWanDataReceived
    }
}

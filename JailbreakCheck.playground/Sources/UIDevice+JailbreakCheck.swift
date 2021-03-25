import Foundation
import UIKit

extension UIDevice {
    
    public enum JailbreakCheckType: Error {
        case cydia,
             symbolicLinks,
             illegalFiles,
             rootPermissions
    }
    
    private typealias JailbreakCheck = () -> Bool
    
    public var isJailbroken: Bool {
        switch performJailbreakCheck() {
        case .success:
            return false
        default:
            return true
        }
    }
    
    public func performJailbreakCheck() -> Result<Void, JailbreakCheckType> {
        let checks: [JailbreakCheckType: JailbreakCheck] = [
            .cydia: {
                let path = "/Applications/Cydia.app"
                if FileManager.default.fileExists(atPath: path) {
                    return false
                }
                if let url = URL(string: "cydia://package/com.com.com"),
                   UIApplication.shared.canOpenURL(url) {
                    return false
                }
                return true
            },
            
            .symbolicLinks: {
                let links = [
                    "/Applications",
                    "/usr/libexec",
                    "/usr/share",
                    "/Library/Wallpaper",
                    "/usr/include"
                ]
                for path in links {
                    let str = NSString(string: path).utf8String
                    let statPtr = UnsafeMutablePointer<stat>.allocate(capacity: 1)
                    if lstat(str, statPtr) == 0 {
                        if statPtr.pointee.st_mode & S_IFMT == S_IFLNK {
                            return false
                        }
                    }
                }
                return true
            },
            
            .illegalFiles: {
                let files = [
                    "/bin/bash",
                    "/etc/apt",
                    "/usr/sbin/sshd",
                    "/Library/MobileSubstrate/MobileSubstrate.dylib",
                    "/Applications/Cydia.app",
                    "/bin/sh",
                    "/var/cache/apt",
                    "/var/tmp/cydia.log"
                ]
                for path in files {
                    let str = NSString(string: path).utf8String
                    let statPtr = UnsafeMutablePointer<stat>.allocate(capacity: 1)
                    if stat(str, statPtr) == 0 {
                        return false
                    }
                }
                return true
            },
            
            .rootPermissions: {
                // try to write something
                let someString = "Z"
                do {
                    try someString.write(toFile: "/private/jailbreak.bin", atomically: true, encoding: .utf8)
                } catch {
                    return true
                }
                return false
            }
        ]
        for (type, check) in checks {
            if !check() {
                return .failure(type)
            }
        }
        return .success(())
    }
        
}

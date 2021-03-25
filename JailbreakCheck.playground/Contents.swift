import UIKit

#if targetEnvironment(simulator)
    print("Note: Simulator's environment is always be treated as jailbroken firmware")
#endif

let isJailbroken = UIDevice.current.isJailbroken
if isJailbroken {
    print("Your device has a jailbroken firmware")
} else {
    print("Your device has an official firmware")
}

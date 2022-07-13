# Local Notifications

## Setup

- Singleton class object

```swift
import UserNotifications


class UNService: NSObject {

    //MARK: - Singleton
    static let shared = UNService()
    private override init() {}

    let unCenter = UNUserNotificationCenter.current()
}
```

## Request Permission

```swift
func authorize() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound, .carPlay]
        unCenter.requestAuthorization(options: options) { isGranted, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Success authrizing UserNotifications")
            }

            guard isGranted else {
                // Handle Error
                print("User DENIED access to UserNotifications")
                return
            }

            self.configure()
        }
    }

    func configure() {
        unCenter.delegate = self
    }
```

## Config Delegate Methods

```swift
extension UNService: UNUserNotificationCenterDelegate {

    // user taps on notificaton and opens app
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("UN did recieve response:\n \(response)")
        completionHandler()
    }

    // if app is in foreground what should happen when notification arrives (maybe no badge)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("UN will present:\n \(notification)")
        let options: UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(options)
    }
}
```

## Authorize on launch

- Launch view

```swift
.onAppear {
     // Best to not add too much to AppDelegate (slows down opening of app)
     UNService.shared.authorize()
 }
```

### Notififcation request config

- content (what your sending)
- trigger
- request (put in queue in UNCenter)

```swift
    func dateRequest(with components: DateComponents) {
        let content = UNMutableNotificationContent()
        content.title = "Date trigger"
        content.body = "It is now the future"
        content.sound = .default
        content.badge = 1

        // ----------- type of Trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(identifier: "userNotification.date", content: content, trigger: trigger)

        unCenter.add(request)

    }
```

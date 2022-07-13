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

## Notififcation request config

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

### Posting

```swift
func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("DID Enter REGION via CoreLocatoin")
        let object: [Any] = [region]

  // POST

        NotificationCenter.default.post(name: NSNotification.Name("internalNotification.enteredRegion"), object: object)
    }
```

### Observing

- SwiftUI uses publisher & onRecieve

**declare top level**

```swift
let pub = NotificationCenter.default.publisher(for: NSNotification.Name("internalNotification.enteredRegion"))
```

- objc method to be called on ViewModel
- can be added to any view

```swift
 .onReceive(pub, perform: { output in
            vm.didEnterRegion()
        })
```

### Setting Attachments

```swift
  func getAttachment(for id: NotificationAttachmentId) -> UNNotificationAttachment? {
        var imageName: String
        switch id {
        case .timer:
            imageName = "TimerAlert"
            print("timer")
        case .date:
            imageName = "DateAlert"
            print("date")
        case .location:
            imageName = "LocationAlert"
            print("location")
        }


        guard let url = Bundle.main.url(forResource: imageName, withExtension: "png") else { return nil }
        do {
            let attachment = try UNNotificationAttachment(identifier: id.rawValue, url: url, options: nil)
            return attachment
        } catch {
            return nil
        }
    }
```

- set on `let content = UNMutableNotificationContent()`

```swift
  // Attachment Image
        if let attachment = getAttachment(for: .timer) {
            content.attachments = [attachment]
        }

```

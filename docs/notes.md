<p align="center">
	<img width="75" alt="LesliCloud logo" src="../app/assets/images/cloud_bell/bell-logo.svg" />
</p>

<h3 align="center">Smart notification system for The Lesli Platform</h3>

<hr/>

- Push notifications (native browser notification through ws)
- Web notification (via bell icon using panel list)
- Flash messages (one time messages)
- Announcements
- Emails

#### notification types 
- info
- danger
- warning
- success

#### sender methods
- webpush: web push notifications (web browser)
- mobilepush: mobile push notifications (iOS/Android app)
- email: email notifications (standard email)


### Quick reference & examples

```ruby
    Courier::Bell::Notification.new(current_user, "New notification created", url:"/bell")
    Courier::Bell::Notification.new(current_user, "New notification created", url:"/bell", category: "info")
    Courier::Bell::Notification.new(current_user, "New notification created", url:"/bell", category: "success")
    Courier::Bell::Notification.new(current_user, "New notification created", url:"/bell", category: "warning")
    Courier::Bell::Notification.new(current_user, "New notification created", url:"/bell", category: "danger")

    Courier::Bell::Notification.new(current_user, "New notification created", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", url:"/bell")
    Courier::Bell::Notification.new(current_user, "New notification created", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", url:"/bell", category: "info")
    Courier::Bell::Notification.new(current_user, "New notification created", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", url:"/bell", category: "success")
    Courier::Bell::Notification.new(current_user, "New notification created", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", url:"/bell", category: "warning")
    Courier::Bell::Notification.new(current_user, "New notification created", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", url:"/bell", category: "danger")
```

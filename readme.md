<p align="center">
	<img width="75" alt="LesliCloud logo" src="./app/assets/images/cloud_bell/bell-logo.svg" />
</p>

<h3 align="center">Smart notification system for The Lesli Platform</h3>

<hr/>

Version 0.1.0-alpha


- Push notifications (native browser notification through ws)
- Web notification (via bell icon using panel list)
- Flash messages (one time messages)
- Announcements
- Emails


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

#### License
-------
Copyright (c) 2020, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

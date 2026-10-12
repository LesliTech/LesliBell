# Notifications

LesliBell notifications are account-scoped messages addressed to individual Lesli users. They support a visual category, delivery-channel metadata, a small lifecycle, optional structured payload data, and an optional destination URL.

## Data Contract

| Attribute | Accepted values or purpose |
| --- | --- |
| `subject` | Notification title shown in the feed |
| `body` | Optional detailed message |
| `url` | Optional destination opened from the feed |
| `category` | `info`, `success`, `warning`, or `danger` |
| `channel` | `web`, `push`, `email`, `dialog`, or `mobile` |
| `status` | `created`, `sent`, or `read` |
| `payload` | Optional JSON metadata for a channel-specific consumer |
| `user_id` | Recipient in the current Lesli account |

Categories and channels describe the notification; they do not deliver email, push, or mobile messages by themselves. Integrations for those transports must consume the stored metadata and update lifecycle state as appropriate.

## Create a Notification

Use `NotificationService` with an authenticated Lesli user. The service derives the account from that user.

```ruby
service = LesliBell::NotificationService.new(current_user)

service.create_for_me(
    subject: "Export complete",
    body: "Your customer export is ready to download.",
    category: :success,
    channel: :web,
    url: "/exports/latest",
    payload: { export_type: "customers" }
)
```

Unknown categories fall back to `info`, and unknown channels fall back to `web`.

To create one notification per recipient, pass an explicit array of user IDs:

```ruby
recipient_ids = current_user.account.users.pluck(:id)

service.create(
    {
        subject: "Maintenance window",
        body: "The application will be unavailable at 02:00 UTC.",
        category: :warning,
        channel: :web
    },
    send_to_user_ids: recipient_ids
)
```

Validate that every recipient belongs to the current account before calling the service. The current implementation creates records from the supplied IDs and does not use the `send_to_role_ids` or `send_to_user_emails` arguments.

## Feed and Read State

`NotificationService#index` returns the current user's records with status `created`, `sent`, or `NULL`, ordered and paginated through the shared Lesli query object. Read notifications no longer appear in the default feed.

```ruby
notifications = LesliBell::NotificationService.new(current_user, query).index
```

The web interface is available at `GET /bell/notifications`. Sending `PUT` or `PATCH` to `/bell/notifications/:id` marks that notification as `read` only when it belongs to the current user and account.

Use `NotificationService#count` for the current user's unread total:

```ruby
unread = LesliBell::NotificationService.new(current_user).count
```

Passing `false` to `index` returns account-wide records rather than limiting them to the current recipient. That mode does not add an authorization policy; expose it only from an already-authorized administrative context.

## Presentation

The feed maps all four categories to semantic Lesli colors and falls back to a neutral style for legacy or unknown values. Subject, body, and URL are escaped by Rails. URLs open in a new tab with `noopener noreferrer`.

See [Database](/engines/bell/about/database) for the stored columns and [Frontend](/engines/bell/about/frontend) for the Tailwind build workflow.

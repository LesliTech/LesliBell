# Database

LesliBell uses collection code `03` and engine code `08`. Its records live in the host application's database and connect to the canonical Lesli account, user, and role tables.

## Migration Registry

| Migration code | Table | Responsibility | Important relationships |
| --- | --- | --- | --- |
| `03.08.00.01.10` | `lesli_bell_accounts` | Engine-specific state for a Lesli account | `lesli_accounts` |
| `03.08.10.01.10` | `lesli_bell_notifications` | Per-user notification content, lifecycle, and delivery metadata | `lesli_users`, `lesli_accounts` |
| `03.08.11.01.10` | `lesli_bell_announcements` | Account announcement content and presentation metadata | `lesli_users`, `lesli_roles`, `lesli_accounts` |
| `03.08.11.03.10` | `lesli_bell_announcement_users` | Per-user association for announcements | `lesli_users`, `lesli_bell_announcements` |

The `03.08.11.02.10` migration is a legacy placeholder. Its table creation is commented out, so it does not create an announcement-activities table and is intentionally excluded from the active registry.

## Notification Schema

| Column | Purpose |
| --- | --- |
| `subject`, `body` | Short title and optional detailed message |
| `url` | Optional destination rendered by the notification feed |
| `category` | `info`, `success`, `warning`, or `danger` |
| `channel` | `web`, `push`, `email`, `dialog`, or `mobile` |
| `status` | `created`, `sent`, or `read`; legacy records may be `NULL` |
| `payload` | Optional JSON metadata for channel-specific consumers |
| `user_id`, `account_id` | Recipient and owning LesliBell account |
| `deleted_at` | Indexed soft-deletion timestamp supplied by the shared record layer |

## Announcement Schema

Announcements store `name`, `message`, an optional `url`, category, status, `path`, `start_at`, `end_at`, and `can_be_closed`. They also reference the creator, optional role, and owning account.

The current `AnnouncementService#list` returns global announcements where `path` is `NULL` and excludes rows already associated through `lesli_bell_announcement_users`. Although path and date-range fields exist in the schema, path-specific and start/end filtering are not currently active in the service. Do not rely on those fields for access control or scheduled delivery.

## Account Scoping

Create and query records through `current_user.account.bell`. The services use that association to keep data inside the current Lesli account, and notification reads add a recipient check. Any administrative use of `NotificationService#index(false)` must add its own authorization before exposing account-wide records.

Notifications, announcements, and announcement-user associations include indexed `deleted_at` columns. Preserve account and user scoping when writing custom queries.

```shell
bin/rails lesli:db:prepare
bin/rails db:migrate:status
```

See [Database Architecture](/engines/lesli/database/structure) and [Migration Versioning](/engines/lesli/database/versioning) for shared conventions.

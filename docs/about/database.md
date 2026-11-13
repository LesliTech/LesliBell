# Database

LesliBell uses collection code `03` and engine code `08`. Its records live in the host application's database and connect to the canonical Lesli account, user, and role tables.

## Migration Registry

| Migration code | Table | Responsibility | Important relationships |
| --- | --- | --- | --- |
| `03.08.00.01.10` | `lesli_bell_accounts` | Engine-specific state for a Lesli account | `lesli_accounts` |
| `03.08.10.01.10` | `lesli_bell_notifications` | Per-user notification content, lifecycle, and delivery metadata | `lesli_users`, `lesli_accounts` |
| `03.08.11.01.10` | `lesli_bell_announcements` | Account announcement content and publication settings | `lesli_users` (author), `lesli_bell_accounts` |
| `03.08.11.03.10` | `lesli_bell_announcement_users` | Per-user announcement dismissals | `lesli_users`, `lesli_bell_announcements` |

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

Announcements store `name`, `message`, an optional `url`, `category`, `active`, `path`, `start_at`, `end_at`, and `can_be_closed`. They reference the author and owning LesliBell account; recipient roles are not part of this contract.

`AnnouncementService#list(path: nil)` returns active announcements in the current account whose optional start is inclusive and optional end is exclusive. It includes global and exact-path announcements and excludes only the current user’s dismissals. The banner query returns complete records without pagination, ordered by `created_at` and `id`. Administrative pagination belongs to `index`.

## Account Scoping

Create and query records through `current_user.account.bell`. The services use that association to keep data inside the current Lesli account, and notification reads add a recipient check. Any administrative use of `NotificationService#index(false)` must add its own authorization before exposing account-wide records.

Notifications and announcements include indexed `deleted_at` columns. Announcement dismissals do not use soft deletion. Preserve account and user scoping when writing custom queries.

```shell
bin/rails lesli:db:prepare
bin/rails db:migrate:status
```

See [Database Architecture](/engines/lesli/database/structure) and [Migration Versioning](/engines/lesli/database/versioning) for shared conventions.

## Announcement Data Contract

Announcements require a local engine account, author, administrative name, and visible message. `category` defaults to `info`; `active` and `can_be_closed` default to `true`. These defaults live in the model, while the database enforces `NOT NULL` without SQL defaults. Fixtures and direct SQL inserts must supply them explicitly. Optional start/end timestamps must form an increasing interval when both are supplied. Empty paths and URLs normalize to null; paths represent an exact application path, and URLs accept internal paths or HTTP/HTTPS destinations.

The original announcements migration replaces `status` with `active` and removes `role_id`. Rebuild disposable development/test databases to adopt this schema. There is no recipient segmentation in this version. Publication filtering is implemented by `AnnouncementService#list`; see [Announcements](/engines/bell/announcements/overview) for the currently implemented query behavior.

## Announcement Dismissals

`lesli_bell_announcement_users` stores one dismissal per announcement and user. Both foreign keys are non-null, and a unique composite index enforces `[announcement_id, user_id]`. `created_at` records the original dismissal time. There is no `deleted_at` column or restoration workflow. The explicit `announcement.dismissals` association uses `LesliBell::Announcement::User`, which inherits directly from Active Record to avoid Core's soft-delete scope.

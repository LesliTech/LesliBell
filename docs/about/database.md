# Database

LesliBell uses collection code `03` and engine code `08`. Its active schema contains notification and announcement data owned by the engine.

| Migration code | Table | Responsibility | Important relationships |
| --- | --- | --- | --- |
| `03.08.00.01.10` | `lesli_bell_accounts` | Engine state for a Lesli account | Required core account reference |
| `03.08.10.01.10` | `lesli_bell_notifications` | User notifications, status, category, and delivery metadata | Core user and core account |
| `03.08.11.01.10` | `lesli_bell_announcements` | Account announcements and visibility rules | Core user, role, and account |
| `03.08.11.03.10` | `lesli_bell_announcement_users` | Per-user announcement association | Core user and announcement |

The `03.08.11.02.10` migration is a legacy placeholder whose table creation remains commented out; it does not create an announcement-activities table and is intentionally excluded from the registry.

Notifications, announcements, and announcement-user associations include indexed `deleted_at` columns. Preserve account and user scoping when querying unread or visible records.

```shell
bin/rails lesli:db:prepare
bin/rails db:migrate:status
```

See [Database Architecture](/engines/lesli/database/structure) and [Migration Versioning](/engines/lesli/database/versioning) for shared conventions.

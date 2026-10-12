# Announcements

Announcements are account-scoped messages intended for broader in-application communication. LesliBell stores their content, category, optional destination, ownership, and presentation metadata separately from per-user notifications.

## Data Contract

| Attribute | Purpose |
| --- | --- |
| `name` | Internal or display name |
| `message` | Announcement content |
| `category` | `info`, `success`, `warning`, or `danger` |
| `url` | Optional destination |
| `path` | Optional page-specific presentation metadata |
| `start_at`, `end_at` | Optional scheduling metadata |
| `can_be_closed` | Whether the presentation may offer dismissal; defaults to `true` |
| `status` | Optional application-defined state |
| `user_id` | User who created the announcement |
| `role_id` | Optional Lesli role reference |

## Create an Announcement

Create account-scoped records through `AnnouncementService`:

```ruby
LesliBell::AnnouncementService.new(current_user).create(
    name: "planned-maintenance",
    message: "The service will be unavailable at 02:00 UTC.",
    category: :warning,
    url: "/status",
    can_be_closed: true
)
```

The service assigns the current user as creator and falls back to `info` when the category is unknown.

## Query Modes

`AnnouncementService#index` returns all announcements in the current LesliBell account, paginated for administrative use:

```ruby
announcements = LesliBell::AnnouncementService.new(current_user, query).index
```

`AnnouncementService#list` is the presentation-oriented query. It currently:

- Limits records to the current account.
- Returns only global announcements where `path` is `NULL`.
- Excludes announcements with an existing announcement-user association.
- Orders results by `start_at` and paginates them.

Path-specific selection and `start_at`/`end_at` date filtering are present as schema concepts but are not active in the current query. These values must not be treated as authorization boundaries or guaranteed delivery scheduling.

## Current Web Surface

`GET /bell/announcements` is the only announcement-specific route currently exposed by `config/routes.rb`. The page is an application entry point; create, update, delete, list JSON, and dismissal routes are not part of the current public route contract.

Use the service layer from trusted application code when creating or querying announcements. Add explicit authorization and account checks before exposing new administrative routes.

See [Database](/engines/bell/about/database) for relationships and stored fields and [Translations](/engines/bell/about/translations) for user-facing labels.

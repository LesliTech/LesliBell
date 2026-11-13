# Announcements

Announcements are account-scoped messages intended for broader in-application communication. LesliBell stores their content, category, optional destination, ownership, and presentation metadata separately from per-user notifications.

## Data Contract

| Attribute | Purpose |
| --- | --- |
| `name` | Required administrative name; surrounding whitespace is removed |
| `message` | Required visible plain-text message |
| `category` | `info`, `success`, `warning`, or `danger`; defaults to `info` |
| `url` | Optional root-relative path or absolute HTTP/HTTPS URL; blank values become `NULL` |
| `path` | Optional exact `request.path`, such as `/support`; blank means all pages. No host, query string, fragment, or wildcard |
| `start_at`, `end_at` | Optional timestamps; when both exist, the end must be strictly later than the start |
| `can_be_closed` | Whether the presentation may offer dismissal; defaults to `true` |
| `active` | Required publication flag, defaults to `true` |
| `user_id` | Required author, assigned by the service from the current user |
| `account_id` | Required local `LesliBell::Account` reference |

## Create an Announcement

Create account-scoped records through `AnnouncementService`:

```ruby
LesliBell::AnnouncementService.new(current_user).create({
    name: "planned-maintenance",
    message: "The service will be unavailable at 02:00 UTC.",
    category: :warning,
    url: "/status",
    can_be_closed: true
})
```

The service assigns the current user as author and falls back to `info` when the category is unknown. Direct model writes validate the supported categories. `active` and `can_be_closed` accept `true` or `false`, never `NULL`. Defaults are defined in the model: `category` uses the enum default, and the boolean flags use `attribute` defaults. The database only enforces non-null values. Fixtures and direct SQL inserts must provide these values explicitly. Changing a model default affects new records, not existing announcements.

Announcements have no recipient or role segmentation in this version. The service no longer accepts `send_to_role_ids`, `send_to_user_ids`, or `send_to_user_emails`. The author is not the audience.

The original migration now uses `active` instead of `status`, removes `role_id`, and requires content, author, and publication flags. Existing disposable development/test databases must be rebuilt; rerunning an already-applied migration will not change their tables.

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

The data contract validates publication settings, but `active`, path-specific selection, and `start_at`/`end_at` filtering are not yet applied by the presentation query. These values must not be treated as authorization boundaries or guaranteed delivery scheduling.

## Current Web Surface

`GET /bell/announcements` is the only announcement-specific route currently exposed by `config/routes.rb`. The page is an application entry point; create, update, delete, list JSON, and dismissal routes are not part of the current public route contract.

Use the service layer from trusted application code when creating or querying announcements. Add explicit authorization and account checks before exposing new administrative routes.

See [Database](/engines/bell/about/database) for relationships and stored fields and [Translations](/engines/bell/about/translations) for user-facing labels.

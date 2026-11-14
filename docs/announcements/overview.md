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

The service assigns the current account and user as owner and author. Omitting the category uses the model default; an unsupported category returns a validation error instead of silently replacing it. `active` and `can_be_closed` accept `true` or `false`, never `NULL`. Defaults are defined in the model: `category` uses the enum default, and the boolean flags use `attribute` defaults. The database only enforces non-null values. Fixtures and direct SQL inserts must provide these values explicitly. Changing a model default affects new records, not existing announcements.

The author is not the audience. Select recipients through `user_ids` and `role_ids`; the old `send_to_*` arguments are not supported. Email selection and email delivery are outside this feature.

The original migration now uses `active` instead of `status`, removes `role_id`, and requires content, author, publication flags, and `audience`. Audience defaults to `account` in the model, not the database. Existing disposable development/test databases must be rebuilt; rerunning an already-applied migration will not change their tables.

## Query Modes

`AnnouncementService#index` returns all announcements in the current LesliBell account, paginated for administrative use:

```ruby
announcements = LesliBell::AnnouncementService.new(current_user, query).index.result
```

`AnnouncementService#list(path: nil)` returns visible banners without pagination or a required `query` argument:

```ruby
announcements = LesliBell::AnnouncementService.new(current_user).list(path: request.path)
```

It:

- Queries only the current account's active, non-deleted announcements.
- Includes records with no start, or `start_at <= Time.current`.
- Includes records with no end, or `end_at > Time.current`.
- Includes global announcements (`path` is `NULL`) and exact matches for the supplied path.
- Excludes only announcements dismissed by the current user.
- Returns full records, including `url`, without administrative pagination.
- Orders by `created_at` ascending, then `id` ascending for deterministic ties.

Both date checks use the same instant. At the exact start an announcement is visible; at the exact end it is no longer visible. Rails handles timestamp conversion through the configured time zone. Omitting `path` returns only global announcements. Pass `request.path`, not a full URL or a query string; subpaths and trailing slashes do not match automatically.

The administrative `index` remains paginated, lists inactive and out-of-window records as well, and uses the same stable creation order. Visibility is evaluated when the query runs; this does not schedule delivery or automatically remove a banner already displayed in an open browser tab.

## Audience

A new announcement without recipients uses `audience: "account"` and is visible to the entire account, subject to publication dates, path, and individual dismissal. Passing user or role IDs without an explicit audience automatically selects `specific`.

```ruby
service = LesliBell::AnnouncementService.new(current_user).create(
    name: "Team maintenance",
    message: "Please save your work before maintenance begins.",
    user_ids: [user.id],
    role_ids: [role.id]
)
announcement = service.result
```

For a specific audience, matching **either** a selected user or a selected role is sufficient. Role membership is evaluated on each banner query; members are not copied into user recipients. Joining or leaving a role changes visibility on the next page request. Subqueries prevent duplicate banners when several matches apply. All selected users and roles must belong to the announcement's Core account, reached through its local LesliBell account.

Users and roles are stored separately in `user_recipients` and `role_recipients`; `recipient_users` and `recipient_roles` expose the selected records. These associations are independent of `dismissals`. General and user-directed announcements work without LesliShield. Selecting roles requires LesliShield; role matching is disabled when that engine is unavailable.

```ruby
service = LesliBell::AnnouncementService.new(current_user).show(announcement.id)
service.update(user_ids: [another_user.id]) # Replace users; keep selected roles.

service = LesliBell::AnnouncementService.new(current_user).show(announcement.id)
service.update(user_ids: [], role_ids: []) # Remove recipients and deactivate.

service = LesliBell::AnnouncementService.new(current_user).show(announcement.id)
service.update(audience: "account", active: true) # Explicitly publish to everyone.
```

Omitting an ID parameter preserves that selection. Sending an empty array removes it; blank entries from HTML selectors are ignored and duplicate IDs are collapsed. Creation and replacement run in one transaction. Invalid recipients or a failed recipient write roll back the announcement and both selections. Service validation errors remain available through `service.result.errors`.

A specific announcement that loses its final recipient remains `specific` and becomes inactive. Removing an individual recipient with `destroy!` applies the same rule. It never becomes public automatically. An explicit change to `audience: "account"` clears both selections and allows publication to everyone. Use the service for replacements and `destroy!` for individual recipient removals; bulk SQL/deletion bypasses model callbacks.

The form offers **Entire account** and **Specific users or roles**, with LesliView multiple selectors restricted to the current account. Explicitly selecting `specific` requires at least one recipient, even when inactive. Submitted selections survive validation errors. The detail page summarizes users and roles; JSON detail/create/update responses include `audience`, `user_ids`, and `role_ids`.

## Core Banners

Core's authenticated layout renders announcements above the main content, in normal document flow. They do not cover forms or disappear automatically. `Lesli::ApplicationLesliController` loads the records through `Lesli::Courier`, invoking `AnnouncementService#list(path: request.path)` before rendering; templates do not select records.

Loading requires both LesliBell and an authenticated user. Full HTML page requests, including Turbo Drive navigation, select banners for the requested path. JSON, Turbo Stream, and Turbo Frame requests do not load global banners. Frame updates leave the surrounding page's banners unchanged; navigation to another page should target `_top`.

Messages are escaped plain text with preserved line breaks. Each category has a color, decorative icon, and accessible category label. Optional URLs appear as a separate **View details** action. Closable banners have a keyboard-accessible close button with an accessible label and message description; non-closable banners have no close control.

Authenticated pages with LesliBell use `turbo-cache-control: no-cache` to avoid restoring dismissed or expired banners from Turbo history snapshots. This disables Turbo snapshot caching for those pages, while keeping Turbo Drive navigation. Visibility is refreshed by page requests, not a background timer. Core continues rendering normally when LesliBell is absent.

## Administration

The management interface at `/bell/announcements` uses LesliView tables, forms, headers, and buttons. Rows link to the announcement detail. The list includes category, publication flag, and start/end dates; it remains paginated. An active flag does not imply current visibility: the date window, page, and individual dismissal also apply.

| Method | Path | Purpose |
| --- | --- | --- |
| GET | `/bell/announcements` | List announcements |
| GET | `/bell/announcements/new` | Creation form |
| POST | `/bell/announcements` | Create |
| GET | `/bell/announcements/:id` | Detail |
| GET | `/bell/announcements/:id/edit` | Edit form |
| PATCH/PUT | `/bell/announcements/:id` | Update |
| DELETE | `/bell/announcements/:id` | Soft-delete |
| POST | `/bell/announcements/:id/dismiss` | Dismiss for the authenticated user |

Forms accept `audience`, `user_ids: []`, `role_ids: []`, `name`, `message`, `category`, `active`, `start_at`, `end_at`, `path`, `url`, and `can_be_closed` inside `announcement`. Dates use the application's configured time zone. Neither controller parameters nor direct service calls can assign or change ownership. All member lookups are scoped to the current account; missing, deleted, and foreign records return 404.

Core's existing authentication and authorization callbacks protect these actions when LesliShield is installed. Refresh resource/action configuration with `bin/rails lesli:db:prepare` and grant the required actions to the appropriate roles, including `dismiss` for users who may close banners.

HTML and Turbo create/update/delete requests redirect with 303 on success. JSON creation returns 201; other successful operations return 200. Invalid creation or update returns 422 with `{ errors: ... }` for JSON, the form for HTML, or a replacement of `announcement-form` for Turbo. Submitted values are retained. Message content is rendered as escaped plain text.

### Service Contract

CRUD methods return the service: inspect `result`, `successful?`, and `errors`. `index` returns a paginated collection in `result`; `show(id)` (also available as `find`) loads the record used by `update` or `destroy`.

```ruby
service = LesliBell::AnnouncementService.new(current_user).show(announcement_id)
service.update(name: "Maintenance", active: false)

if service.successful?
    announcement = service.result
else
    errors = service.result.errors
end
```

`create` and `update` return invalid records and their errors rather than raising for validation failures. `destroy` soft-deletes the loaded record and preserves its dismissals. The banner query `list(path:)` continues to return a relation directly.

## Individual Dismissal

`user` on an announcement is its author. `dismissals` is a separate association of `LesliBell::Announcement::User` records stored in `lesli_bell_announcement_users`. These records identify readers who closed the banner, not its audience.

```ruby
service = LesliBell::AnnouncementService.new(current_user).dismiss(announcement.id)
dismissal = service.result

dismissal.user       # The authenticated reader
dismissal.created_at # When that reader first dismissed the announcement
```

The operation finds the announcement within the current account and raises `ActiveRecord::RecordNotFound` for missing, deleted, or inaccessible IDs. An announcement with `can_be_closed: false` raises `ActiveRecord::RecordInvalid` without creating a dismissal. Repeated dismissals return the existing record without changing its timestamp. A unique database index on `[announcement_id, user_id]` prevents duplicates, including overlapping requests.

Dismissals require both references and have no soft-delete column or restore operation. Announcement soft deletion retains their history. The dismissal endpoint returns `{ id, dismissed_at }` for JSON and a Turbo removal targeting `announcement-ID` only after persistence succeeds. Repeated requests return the original dismissal. HTML requests redirect to the management list. Non-closable announcements return 422. Turbo dismissal responses for validation failure (422), denied authorization (403), and missing records (404) show an error notification without removing the banner.

The old `AnnouncementService#read` method is removed: it incorrectly updated notifications. Call `dismiss(id)` for announcements. The original dismissal migration now removes `deleted_at`, requires both references, and adds the unique index; rebuild disposable development/test databases to adopt these changes.

## Compatibility Changes

This implementation changes the previous announcement API and schema:

- `active` replaces `status`. `name` and `message` are required, and `user` identifies the author.
- `audience` is required and defaults to `account` in the model. Use `user_ids` and `role_ids` for specific audiences; the previous single `role_id` and `send_to_*` arguments are removed. Email delivery is not implemented.
- `dismissals` replaces the old `users` association. `dismiss(id)` replaces `read`; opening a page never creates a dismissal. Dismissal records no longer use soft deletion.
- `list(path:)` returns a relation of visible banners. `index` returns the paginated administration collection through the service result. CRUD callers should check `successful?` and read `result`.
- Malformed dates are validation errors, not empty scheduling limits. Optional blank dates remain valid. The end must be later than the start when both are provided.
- HTML and Turbo form submissions redirect with 303. Page actions render HTML even when Turbo preserves its stream Accept header after a redirect. JSON responses remain JSON; validation and dismissal operations retain their Turbo Stream responses.

Original migrations were edited because these tables are still considered disposable. Existing development/test databases need a rebuild, which deletes their data; simply running `db:migrate` does not rerun the edited migrations. If a consumer must preserve existing records, write and test an explicit data migration before upgrading: rename publication state, populate required fields and audience, remove duplicate dismissal pairs, and enforce the new constraints. No automatic migration of legacy records is provided.

See [Testing](/engines/bell/announcements/testing) for regression coverage and database verification.

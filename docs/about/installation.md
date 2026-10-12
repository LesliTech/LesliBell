# Installation

LesliBell provides account-scoped notifications and announcements. It requires Lesli `~> 5.1.0` and uses the host application's users, roles, accounts, and database.

## Install the Engine

```shell
bundle add lesli_bell
```

The standard Lesli router mounts the engine at `/bell`:

```ruby
Rails.application.routes.draw do
  Lesli::Router.mount(self)
end
```

For a manual mount:

```ruby
Rails.application.routes.draw do
  mount LesliBell::Engine => "/bell"
end
```

Prepare the database and initialize existing accounts:

```shell
bin/rails lesli:db:prepare
```

This command adds LesliBell's migrations to the host application, prepares the database, and initializes the engine record used by each existing Lesli account. Run it again after adding LesliBell to an established application.

## Verify the Installation

```shell
bin/rails routes -g bell
bin/rails server
```

Visit `http://127.0.0.1:3000/bell`. The current route surface is:

| Method | Path | Purpose |
| --- | --- | --- |
| `GET` | `/bell` | Shared LesliBell dashboard |
| `GET` | `/bell/notifications` | Current user's unread notification feed |
| `GET` | `/bell/notifications/new` | Reserved notification creation page |
| `PUT/PATCH` | `/bell/notifications/:id` | Mark one notification as read |
| `GET` | `/bell/announcements` | Announcement application entry point |

Lesli's shared engine routes also provide dashboard editing and reusable item endpoints. Treat the output of `bin/rails routes -g bell` as the authoritative route list for the installed versions.

## Development Data

LesliBell loads sample notifications and announcements only in development or when `Lesli.config.demo` is enabled:

```shell
bin/rails lesli:db:seed
```

The seeders require at least one Lesli account and user. They are intended for disposable development or demo environments.

See [Notifications](/engines/bell/notifications/overview), [Announcements](/engines/bell/announcements/overview), [Database](/engines/bell/about/database), [Translations](/engines/bell/about/translations), and [Frontend](/engines/bell/about/frontend) for integration details.

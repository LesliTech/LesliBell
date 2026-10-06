# Installation

LesliBell provides account-scoped notifications and announcements. It requires Lesli `~> 5.1.0` and uses the host application's users, roles, accounts, and database.

## Install and Mount

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

## Verify the Installation

```shell
bin/rails routes -g bell
bin/rails server
```

Visit `http://127.0.0.1:3000/bell`. The engine exposes notification and announcement resources in addition to its standard health and root routes.

See [Translations](/engines/bell/about/translations) and [Database](/engines/bell/about/database) for integration details.

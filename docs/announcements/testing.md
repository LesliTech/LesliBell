# Testing

Announcement tests cover the model, service, database constraints, administration controller, seed data, and Core banner integration. See [Announcements](/engines/bell/announcements/overview) for the public API and incompatible changes.

## Standalone Engine

Run from LesliBell with its bundle installed:

```shell
bundle exec rake test
```

The engine works without LesliShield. Tests that require Shield's role membership or authorization are skipped when it is absent; general and user-specific audience tests still run. To exercise role membership and authorization, include LesliShield in the test host's bundle and install its migrations as well.

Use a dedicated database for each test configuration. To load the checked-in Core/Bell schema and run the default standalone suite with SQLite:

```shell
RAILS_ENV=test DATABASE_URL=sqlite3:/tmp/lesli_bell_test.sqlite3 bundle exec rake db:schema:load test
```

For PostgreSQL, create a dedicated test database and supply its connection URL:

```shell
RAILS_ENV=test DATABASE_URL=postgresql://localhost/lesli_bell_test bundle exec rake db:schema:load test
```

`db:schema:load` replaces tables: never point these commands at a development or production database containing data you need. A test host that also loads Shield needs a schema including Shield's tables. Keep that host schema separate from the standalone Core/Bell schema; `SCHEMA=/path/to/test-host-schema.rb` selects an alternate schema file for Rails tasks.

## Regression Coverage

- Required content, supported categories, safe destinations, optional dates, malformed dates, and date ordering.
- Account-scoped CRUD and ownership assigned by the server.
- Active, inactive, future, expired, global, and exact-page announcements.
- General, user, role, and combined audiences; current role membership; recipient replacement and transaction rollback.
- Individual, repeatable dismissals and rejection of non-closable announcements.
- Page requests that never create dismissals, empty banner areas, escaped multiline text, and English/Spanish interface labels.
- Turbo/JSON responses, validation form retention, and HTML navigation after Turbo redirects.
- Foreign keys, non-null columns, and unique dismissal/recipient pairs, tested with writes that bypass model validations.
- Repeatable announcement seeds that preserve customization and expose validation failures.

Database rejection tests use nested transactions/savepoints so a deliberate constraint violation does not invalidate later assertions on PostgreSQL.

## Builder Integration

The Builder tests authenticate real users, use the mounted `/bell/announcements` routes, and render the complete application layout. Two accounts create independent announcements; users in one account dismiss banners without affecting other readers. The integration also follows a Turbo create redirect with its original Accept header.

From LesliBuilder, after preparing a dedicated host test database:

```shell
RAILS_ENV=test DATABASE_URL=sqlite3:/tmp/lesli_builder_test.sqlite3 bundle exec rails db:schema:load
RAILS_ENV=test DATABASE_URL=sqlite3:/tmp/lesli_builder_test.sqlite3 bundle exec rails test test/integration
```

These are server-side integration tests. They do not automate browser keyboard interaction or visual layout inspection.

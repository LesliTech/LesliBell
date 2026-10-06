# Translations

LesliBell owns user-facing labels below the `lesli_bell` namespace. It currently ships locale files for English, Spanish, French, Italian, and Portuguese under `config/locales`.

Add labels by feature bucket:

```yaml
en:
  lesli_bell:
    notifications:
      title: "Notifications"
      empty: "You have no notifications"
    announcements:
      title: "Announcements"
```

Use the complete path:

```erb
<%= I18n.t("lesli_bell.notifications.title") %>
```

The locale files are currently empty. A translation change must therefore include both the new keys and replacement of the corresponding hard-coded interface labels. Keep notification content supplied by callers separate from interface labels owned by the engine.

When LesliBabel is installed, scan and import local values with:

```shell
bin/rails lesli_babel:scan
bin/rails lesli_babel:import
```

Add the same key to every supported locale and preserve interpolation tokens. The engine locale files remain the version-controlled source of truth.

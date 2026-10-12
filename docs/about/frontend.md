# Frontend

LesliBell renders inside Lesli's authenticated application shell. The notification feed uses LesliView for its container, header, toolbar, actions, and empty state, while Tailwind CSS provides engine-specific presentation.

## Tailwind Stylesheet

The editable entrypoint and generated Rails asset are separate:

```text
source/tailwind/application.tailwind.css
        ↓ build
app/assets/stylesheets/lesli_bell/application.tailwind.css
```

Edit the file under `source/tailwind`; do not edit the compiled stylesheet by hand. Commit the generated asset whenever the source or a scanned template changes.

LesliBell's entrypoint disables automatic source discovery and scans the notification view explicitly:

```css
@source "../../app/views/lesli_bell/notifications/index.html.erb";
```

Add an `@source` rule when another template or helper starts using Tailwind utilities. The entrypoint references LesliAssets' Tailwind theme so semantic utilities such as `bg-info-50`, `border-warning-300`, and `text-danger-900` compile against Lesli's design tokens.

Tailwind cannot detect class-name fragments such as `"bg-#{category}-50"`. Map runtime states to complete class strings, as the notification view does for `info`, `success`, `warning`, and `danger`.

## Build the Asset

From a standard Lesli development workspace, run the shared builder:

```shell
cd gems/LesliAssets
make build.tailwind
```

Use the watcher while editing templates or Tailwind sources:

```shell
make watch.tailwind
```

The builder discovers LesliBell's entrypoint and writes the compiled output to `app/assets/stylesheets/lesli_bell/application.tailwind.css`.

## View Conventions

- Wrap authenticated pages with `LesliView::Layout::Container`.
- Prefer LesliView components for headers, toolbars, buttons, and empty states.
- Use complete semantic class names for notification categories.
- Preserve visible `focus-visible` states for links and actions.
- Mark decorative icons with `aria-hidden="true"` and give icon-only actions an accessible label.
- Keep notification data shaping and account scoping in services rather than templates.
- Treat compiled CSS and JavaScript under `app/assets` as generated files.

See [Views and Layouts](/engines/lesli/frontend/views), [Styles with Tailwind CSS](/engines/lesli/frontend/styles), and the [LesliView documentation](/gems/view/) for shared conventions and component APIs.

<div align="center">
    <h1 align="center">
        <img width="100" alt="LesliBell" src="./app/assets/images/lesli_bell/bell-logo.svg" />
    </h1>
    <h3 align="center">Notifications and announcements for the Lesli Framework.</h3>
</div>

<br />

<div align="center">
    <a target="_blank" href="https://github.com/LesliTech/LesliBell/actions/workflows/lesli-ci-tests.yaml">
        <img
            alt="LesliBell test status"
            src="https://img.shields.io/github/actions/workflow/status/LesliTech/LesliBell/lesli-ci-tests.yaml?branch=master&style=for-the-badge&logo=github&label=tests">
    </a>
    <a target="_blank" href="https://rubygems.org/gems/lesli_bell">
        <img alt="Gem Version" src="https://img.shields.io/gem/v/lesli_bell?style=for-the-badge&logo=ruby">
    </a>
    <a target="_blank" href="https://codecov.io/github/LesliTech/LesliBell">
        <img alt="Codecov" src="https://img.shields.io/codecov/c/github/LesliTech/LesliBell?style=for-the-badge&logo=codecov">
    </a>
    <a target="_blank" href="https://sonarcloud.io/project/overview?id=LesliTech_LesliBell">
        <img alt="Sonar Quality Gate" src="https://img.shields.io/sonar/quality_gate/LesliTech_LesliBell?server=https%3A%2F%2Fsonarcloud.io&style=for-the-badge&logo=sonarqubecloud&label=Quality">
    </a>
</div>

<br />

<div align="center">
    <img
        style="width:100%;max-width:800px;border-radius:6px;"
        alt="LesliBell notifications and announcements"
        src="./docs/images/screenshot.png" />
</div>

---

<br />

## Introduction

LesliBell is the official notifications and announcements engine for the [Lesli Framework](https://github.com/LesliTech/Lesli).

It provides account-scoped communication tools that integrate with Lesli users, permissions, navigation, and shared application infrastructure.

<br />

## Features

- User notification feeds with unread counts and read status
- Notification categories for informational, success, warning, and danger messages
- Delivery-channel metadata for web, push, email, dialog, and mobile notifications
- Account-scoped announcements
- Announcement visibility controls, including paths and date ranges
- Pagination and integration with the standard Lesli interface

<br />

## Try LesliBell

- [Try the online demo](https://demo.lesli.dev/)
- [Run the Docker demo](https://github.com/LesliTech/lesli-docker-demo)

<br />

## Quick Start

### Requirements

- A Rails application with [Lesli](https://rubygems.org/gems/lesli) 5.1 or newer
- SQLite by default, or PostgreSQL when preferred by the host application

### Install LesliBell

Add the engine to the host Rails application and prepare its database:

```shell
bundle add lesli_bell
bin/rails db:prepare
```

### Mount the engine

Applications using Lesli's standard router mount LesliBell automatically at `/bell`:

```ruby
# config/routes.rb
Rails.application.routes.draw do
    Lesli::Router.mount(self)
end
```

If the application does not use the standard Lesli router, mount the engine directly:

```ruby
# config/routes.rb
Rails.application.routes.draw do
    mount LesliBell::Engine => "/bell"
end
```

Start Rails and visit [http://127.0.0.1:3000/bell](http://127.0.0.1:3000/bell):

```shell
bin/rails server
```

<br />

## Development

Clone LesliBell into the host application's `engines` directory:

```shell
cd RailsApp
mkdir -p engines
git clone https://github.com/LesliTech/LesliBell.git engines/LesliBell
```

Reference the local engine from the host application's `Gemfile`:

```ruby
gem "lesli_bell", path: "engines/LesliBell"
```

Install dependencies, prepare the host database, and start Rails:

```shell
bundle install
bin/rails db:prepare
bin/rails server
```

### Tests

From a complete Lesli development workspace, run the engine test suite from the LesliBell directory:

```shell
cd engines/LesliBell
bin/rails test
```

<br />

## Documentation

- [Lesli website](https://www.lesli.dev/)
- [Documentation](https://www.lesli.dev/engines/bell)
- [Release notes](https://github.com/LesliTech/LesliBell/releases)
- [Issue tracker](https://github.com/LesliTech/LesliBell/issues)
- [Source code](https://github.com/LesliTech/LesliBell)

<br />

## Community

- [X: @LesliTech](https://x.com/LesliTech)
- [hello@lesli.tech](mailto:hello@lesli.tech)
- [https://www.lesli.tech](https://www.lesli.tech)

<br />

## License

Copyright (c) 2026, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see [https://www.gnu.org/licenses/](https://www.gnu.org/licenses/).

The complete license text is available in the [license file](./license).

---

<br />
<br />

<div align="center">
    <img width="80" alt="Lesli icon" src="https://cdn.lesli.tech/lesli/brand/app-icon.svg" />
    <h3 align="center">The Open-Source SaaS Development Framework for Ruby on Rails.</h3>
</div>

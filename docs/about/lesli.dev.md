<div class="documentation-header">
    <img alt="LesliBell logo" src="../app/assets/images/lesli_bell/bell-logo.svg" />
    <h1>
        Notifications & Announcements System
    </h1>
</div>

<div class="documentation-statics">
    <a target="blank" href="https://rubygems.org/gems/lesli_bell">
        <img src="https://badge.fury.io/rb/lesli_bell.svg" alt="Gem Version" height="24">
    </a>
</div>


### Quick start

```shell
# Add LesliBell engine
bundle add lesli_bell
```

```shell
# Setup database
rake lesli:db:setup
```

```ruby
# Load LesliBell
Rails.application.routes.draw do
    mount LesliBell::Engine => "/bell"
end
```

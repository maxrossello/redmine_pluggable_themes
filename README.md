# Redmine Pluggable Themes

Allows Redmine plugins to provide themes just like other assets.

Possible use cases:
* Easier installation of themes
* Theme enhancements integrated with code extensions
* Deployment of customer-specific customizations including theme, in a single package

## Version

Tests are performed through [redmine_testsuites](https://github.com/maxrossello/redmine_testsuites) including all the plugins it supports.

The plugin version corresponds to minimum version of Redmine required. Look at dedicated branch for each Redmine version.

## Installation

Place the plugin code under the plugins directory.

    cd {redmine root}
    git clone https://github.com/maxrossello/redmine_pluggable_themes.git plugins/redmine_pluggable_themes

## How to export a theme

* Set a dependency of your plugin to this plugin in your init.rb. The following code checks the dependency without need of particular care to the plugin names.

<pre>
    Rails.configuration.after_initialize do
        Redmine::Plugin.find(:your_plugin_name).requires_redmine_plugin :redmine_pluggable_themes, :version_or_higher => '1.0.0'
    end
</pre>

* Create a folder assets/themes
* Put there any theme you want to list in Redmine settings

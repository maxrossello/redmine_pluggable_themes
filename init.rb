require 'redmine'

Rails.logger.info 'Redmine pluggable themes'

Redmine::Plugin.register :redmine_pluggable_themes do
  name 'Redmine Pluggable Themes plugin'
  author 'Massimo Rossello'
  description 'Allows plugins to export themes in assets'
  version '1.0.0'
  url 'https://github.com/maxrossello/redmine_pluggable_themes.git'
  author_url 'https://github.com/maxrossello'
  requires_redmine :version_or_higher => '3.4.0'

end

require_dependency 'themes_patch'


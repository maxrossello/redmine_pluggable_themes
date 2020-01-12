# Redmine - project management software
# Copyright (C) 2006-2017  Jean-Philippe Lang
#
# Redmine plugin for Pluggable Themes
# Copyright (C) 2018       Massimo Rossello
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require File.expand_path('../../test_helper', __FILE__)

class ThemesTest < Redmine::IntegrationTest

  include CommonPluggableThemesTestHelper
  
  def setup
    default_setup
    @theme = Redmine::Themes.themes.last
    Setting.ui_theme = @theme.id
    @path = @theme.path.split('public')[1]
  end

  def teardown
    default_teardown
    Setting.ui_theme = ''
  end

  def test_application_css
    get '/'

    assert_response :success
    assert_select "link[rel=stylesheet][href^=?]", "#{@path}/stylesheets/application.css"
  end

  def test_without_theme_js
    # simulate a state theme.js does not exists
    @theme.javascripts.clear
    get '/'

    assert_response :success
    assert_select "script[src^=?]", "#{@path}/javascripts/theme.js", 0
  end

  def test_with_theme_js
    # Simulates a theme.js
    @theme.javascripts << 'theme'
    get '/'

    assert_response :success
    assert_select "script[src^=?]", "#{@path}/javascripts/theme.js", 1
  ensure
    @theme.javascripts.delete 'theme'
  end

  def test_use_default_favicon_if_theme_provides_none
    get '/'

    assert_response :success
    assert_select 'link[rel="shortcut icon"][href^="/favicon.ico"]'
  end

  def test_use_theme_favicon_if_theme_provides_one
    # Simulate a theme favicon
    @theme.favicons << 'a.ico'
    get '/'

    assert_response :success
    assert_select 'link[rel="shortcut icon"][href^=?]', "#{@path}/favicon/a.ico"
  ensure
    @theme.favicons.delete 'a.ico'
  end

  def test_use_only_one_theme_favicon_if_theme_provides_many
    @theme.favicons.concat %w{b.ico a.png}
    get '/'

    assert_response :success
    assert_select 'link[rel="shortcut icon"]', 1
    assert_select 'link[rel="shortcut icon"][href^=?]', "#{@path}/favicon/b.ico"
  ensure
    @theme.favicons.delete("b.ico")
    @theme.favicons.delete("a.png")
  end

  def test_with_sub_uri
    Redmine::Utils.relative_url_root = '/foo'
    @theme.javascripts << 'theme'
    @theme.favicons << 'a.ico'
    get '/'

    assert_response :success
    assert_select "link[rel=stylesheet][href^=?]", "/foo#{@path}/stylesheets/application.css"
    assert_select "script[src^=?]", "/foo#{@path}/javascripts/theme.js"
    assert_select 'link[rel="shortcut icon"][href^=?]', "/foo#{@path}/favicon/a.ico"
  ensure
    Redmine::Utils.relative_url_root = ''
  end
end

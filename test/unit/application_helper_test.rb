# encoding: utf-8
#
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

class ApplicationHelperTest < Redmine::HelperTest
  #include ERB::Util
  include Rails.application.routes.url_helpers

  def setup
    super
  end

  def test_image_tag_should_pick_the_theme_image_if_it_exists
    theme = Redmine::Themes.themes.last
    theme.images << 'image.png'
    path = theme.path.split('public')[1]

    with_settings :ui_theme => theme.id do
      assert_match %|src="#{path}/images/image.png"|, image_tag("image.png")
      assert_match %|src="/images/other.png"|, image_tag("other.png")
    end
  ensure
    theme.images.delete 'image.png'
  end

end

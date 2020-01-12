# Redmine plugin for Pluggable Themes
# Copyright (C) 2018    Massimo Rossello https://github.com/maxrossello
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'redmine'

Rails.logger.info 'Redmine pluggable themes'

Redmine::Plugin.register :redmine_pluggable_themes do
  name 'Redmine Pluggable Themes plugin'
  author 'Massimo Rossello'
  description 'Allows plugins to export themes in assets'
  version '4.0.0'
  url 'https://github.com/maxrossello/redmine_pluggable_themes.git'
  author_url 'https://github.com/maxrossello'
  requires_redmine :version_or_higher => '4.0.0'

end

require_dependency 'themes_patch'


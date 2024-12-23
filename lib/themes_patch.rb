# Redmine plugin for Pluggable Themes
#
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

module ThemesPatch
  module ClassPatch
    def scan_themes
      dirs = Dir.glob(["#{Rails.root}/plugins/*/app/assets/themes/*", "#{Rails.root}/plugins/*/assets/themes/*"]).select do |f|
        # A theme should at least override application.css
        File.directory?(f) && File.exist?("#{f}/stylesheets/application.css")
      end
      dirs.collect! {|dir| Redmine::Themes::Theme.new(dir)}
      dirs = super + dirs
      dirs.sort { |x,y| x <=> y }
    end
  end
end

unless Redmine::Themes.singleton_class.included_modules.include?(ThemesPatch::ClassPatch)
  Redmine::Themes.singleton_class.send(:prepend, ThemesPatch::ClassPatch)
end


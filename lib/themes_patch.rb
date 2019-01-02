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
    def self.included(base) # :nodoc:
		base.extend(ClassMethods)

    	base.class_eval do
   			unloadable
            class << self
      		    alias_method_chain :scan_themes, :plugins
            end
    	end
  	end

	module ClassMethods
		def scan_themes_with_plugins
        	dirs = Dir.glob("#{Rails.public_path}/plugin_assets/*/themes/*").select do |f|
	        	# A theme should at least override application.css
        		File.directory?(f) && File.exist?("#{f}/stylesheets/application.css")
    	 	end
	        dirs.collect! {|dir| Redmine::Themes::Theme.new(dir)}
            dirs = scan_themes_without_plugins + dirs
            dirs.sort { |x,y| x <=> y }
		end
	end
end

module ThemePatch
    def self.included(base) # :nodoc:
    	base.send(:include, InstanceMethods)
    	base.class_eval do
   			unloadable
			alias_method_chain :stylesheet_path, :plugins
			alias_method_chain :image_path,      :plugins
			alias_method_chain :javascript_path, :plugins
			alias_method_chain :favicon_path,    :plugins
    	end
  	end

    module InstanceMethods
        def theme_path
			@path.match('^.*public(/.*)')[1]
		end

		def stylesheet_path_with_plugins(source)
        	"#{theme_path}/stylesheets/#{source}"
		end

        def image_path_with_plugins(source)
        	"#{theme_path}/images/#{source}"
        end

        def javascript_path_with_plugins(source)
        	"#{theme_path}/javascripts/#{source}"
        end

        def favicon_path_with_plugins
        	"#{theme_path}/favicon/#{favicon}"
        end
    end
end

unless Redmine::Themes.included_modules.include?(ThemesPatch)
    Redmine::Themes.send(:include, ThemesPatch)
end

unless Redmine::Themes::Theme.included_modules.include?(ThemePatch)
    Redmine::Themes::Theme.send(:include, ThemePatch)
end


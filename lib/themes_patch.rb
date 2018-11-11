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


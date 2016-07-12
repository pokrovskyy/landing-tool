require 'paperclip'
require 'zip'
require 'materialize-sass'
require 'jquery-ui-rails'

module LandingTool
  class Engine < ::Rails::Engine
    config.autoload_paths += %W(#{root}/app/models/landing_tool/concerns)
    isolate_namespace LandingTool
  end
end
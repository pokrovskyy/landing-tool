module LandingTool
  class ApplicationController < ActionController::Base
    if c = (YAML.load(File.read('config/landing_tool.yml'))[Rails.env]['auth'] rescue false)
      if (c.keys & ['name', 'password']).length == 2
        http_basic_authenticate_with :name => c['name'], :password => c['password'], :except => :serve_page
      end
    end

    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    before_filter {
      @breadcrumbs = []
    }

    def sitemap
      headers['Content-Type'] = 'application/xml'
      respond_to do |format|
        format.xml {
          @variations = LandingTool::LandingPage.active.map(&:variations).flatten.select(&:active?)
          render :template => 'landing_tool/sitemap', :layout => false
        }
      end
    end

    protected

    def add_crumb(title, url)
      @breadcrumbs << { :title => title, :url => url }
    end
  end
end

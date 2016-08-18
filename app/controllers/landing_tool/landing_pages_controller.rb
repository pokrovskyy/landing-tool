module LandingTool
  class LandingPagesController < LandingTool::ApplicationController
    protect_from_forgery :except => :serve_page

    before_action :set_landing_page, only: [:show, :edit, :update, :destroy, :enable, :disable]
    before_filter {
      add_crumb 'Landing Pages', :landing_pages
    }
    before_filter :only => [:show, :edit, :update] {
      add_crumb(@landing_page.title, landing_page_path(@landing_page))
    }
    before_filter :only => [:new, :create] {
      add_crumb('New', :new_landing_page)
    }

    def index
      @landing_pages = LandingTool::LandingPage.all
      @page_title = 'Landing Pages'
      unless (@search_term = params[:search_term]).blank?
        @landing_pages = @landing_pages.where('id = ? OR title like ? OR category like ? OR notes like ?', @search_term, *(["%#{@search_term}%"] * 3))
      end
    end

    def show
      @page_title = @landing_page.title
      @landing_page_variations = @landing_page.variations
      unless (@search_term = params[:search_term]).blank?
        #@landing_pages = @landing_pages.where('id = ? OR title like ? OR category like ? OR notes like ?', @search_term, *(["%#{@search_term}%"] * 3))
      end
    end

    def new
      @landing_page = LandingTool::LandingPage.new
      @page_title = "New Landing Page"
    end

    def edit
      @page_title = "Edit #{@landing_page.title}"
    end

    def create
      @page_title = "New Landing Page"
      @landing_page = LandingTool::LandingPage.new(landing_page_params)
      respond_to do |format|
        if @landing_page.save
          format.html { redirect_to @landing_page, notice: 'Landing page was successfully created.' }
        else
          format.html { render :new }
        end
      end
    end

    def update
      @page_title = "Edit Landing Page"
      respond_to do |format|
        if @landing_page.update(landing_page_params)
          format.html { redirect_to @landing_page, notice: 'Landing page was successfully updated.' }
        else
          format.html { render :edit }
        end
      end
    end

    def destroy
      @landing_page.destroy
      respond_to do |format|
        format.html { redirect_to landing_pages_url, notice: 'Landing page was successfully destroyed.' }
      end
    end

    def disable
      @landing_page.deactivate!
      flash[:notice] = "Landing page deactivated"
      redirect_to :back
    end

    def enable
      @landing_page.activate!
      flash[:notice] = "Landing page activated"
      redirect_to :back
    end

    def serve_page
      if request.env['REQUEST_URI'][-1] != '/'
        redirect_to (request.env['REQUEST_URI'] + '/')
        return
      end
      full_path = request.fullpath.reverse.chomp(landing_tool.root_path.reverse).chomp('/').reverse
      url = full_path.split('/')[0]
      path = full_path.split('/')[1..-1].join('/').split('?').first
      path = nil if path.blank?
      variation = LandingTool::LandingPageVariation.active.where(:url => url).first
      if variation && variation.landing_page.active? && (variation.ensure_compiled_templates rescue false)
        send_file "#{variation.compiled_folder}/#{path || 'index.html'}", :disposition => :inline
      else
        raise ActionController::RoutingError.new('Not Found')
      end
    end

    private

    def set_landing_page
      @landing_page = LandingTool::LandingPage.find(params[:id])
    end

    def landing_page_params
      params.fetch(:landing_page, {}).permit(:title, :templates, :notes, :category)
    end
  end
end
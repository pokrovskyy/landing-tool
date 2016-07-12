module LandingTool
  class LandingPageVariationsController < ApplicationController
    before_action :set_landing_page
    before_action :set_landing_page_variation, only: [:show, :edit, :update, :destroy, :enable, :disable]
    before_filter {
      add_crumb 'Landing Pages', :landing_pages
      add_crumb @landing_page.title, landing_page_path(@landing_page)
    }
    before_filter :only => [:show, :edit, :update] {
      add_crumb(@landing_page_variation.title, edit_landing_page_landing_page_variation_path(@landing_page, @landing_page_variation))
    }
    before_filter :only => [:new, :create] {
      add_crumb('New Variation', new_landing_page_landing_page_variation_path(@landing_page))
    }

    def new
      @landing_page_variation = @landing_page.variations.new(:url => @landing_page.title.parameterize)
      @page_title = "New Landing Page Variation"
    end

    def edit
      @page_title = "Edit #{@landing_page_variation.title}"
    end

    def create
      @page_title = "New Landing Page Variation"
      @landing_page_variation = @landing_page.variations.build(landing_page_variation_params)
      respond_to do |format|
        if @landing_page_variation.save
          format.html { redirect_to @landing_page, notice: 'Landing page variation was successfully created.' }
        else
          format.html { render :new }
        end
      end
    end

    def update
      @page_title = "Edit Landing Page Variation"
      respond_to do |format|
        if @landing_page_variation.update(landing_page_variation_params)
          format.html { redirect_to @landing_page, notice: 'Landing page variation was successfully updated.' }
        else
          format.html { render :edit }
        end
      end
    end

    def destroy
      @landing_page_variation.destroy
      respond_to do |format|
        format.html { redirect_to @landing_page, notice: 'Landing page variation was successfully destroyed.' }
      end
    end

    def disable
      @landing_page_variation.deactivate!
      flash[:notice] = "Landing page variation deactivated"
      redirect_to :back
    end

    def enable
      @landing_page_variation.activate!
      flash[:notice] = "Landing page variation activated"
      redirect_to :back
    end

    private

    def set_landing_page
      @landing_page = LandingTool::LandingPage.find(params[:landing_page_id])
    end

    def set_landing_page_variation
      @landing_page_variation = @landing_page.variations.find(params[:id])
    end

    def landing_page_variation_params
      params.fetch(:landing_page_variation, {}).permit(:title, :notes, :url, :data => {}).tap do |whitelisted|
        whitelisted[:data] = params[:landing_page_variation][:data]
      end
    end
  end
end
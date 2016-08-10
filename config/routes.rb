LandingTool::Engine.routes.draw do
  concern :deactivatable do
    member do
      put 'disable'
      put 'enable'
    end
  end

  resources :landing_pages do
    concerns :deactivatable
    resources :landing_page_variations, :except => [:index, :show], :path => 'variations' do
      concerns :deactivatable
    end
  end
  root to: 'landing_pages#index'

  get "sitemap.xml", to: "application#sitemap", format: "xml"
  get "*path", to: "landing_pages#serve_page"
end

Rails.application.routes.draw do
  get "*path", to: "landing_tool/landing_pages#serve_page"
end
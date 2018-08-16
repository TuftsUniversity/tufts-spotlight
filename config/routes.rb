Rails.application.routes.draw do
  
  mount Blacklight::Oembed::Engine, at: 'oembed'
  mount Riiif::Engine => '/images', as: 'riiif'
  root to: 'spotlight/exhibits#index'

  mount Spotlight::Engine, at: 'spotlight'
  mount Blacklight::Engine => '/'
#  root to: "catalog#index" # replaced by spotlight root path
    concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  devise_for :users
  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  # Our fedora resources
  resources :exhibits, only: [] do
    resources :fedora_resources, only: [:create, :update] do
    end

    resources :tdl_resources, controller: 'tufts/tdl_resources', only: :create, as: 'tufts_tdl_resources' do
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

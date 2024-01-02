# frozen_string_literal: true

Rails.application.routes.draw do
  concern :searchable, Blacklight::Routes::Searchable.new

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

  # TODO: why are these different maybe just have one
  if Rails.env.production? || Rails.env.tdldev?
    devise_for :users, controllers: { omniauth_callbacks: "omniauthcallbacks" }, skip: [:sessions]
    devise_scope :user do
      get 'users/sign_in', to: 'omniauth#new'
      post 'sign_in', to: 'omniauth#new', as: :new_user_session
      post 'sign_in', to: 'omniauth_callbacks#shibboleth', as: :new_session
      get 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
      get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    end
  else
    # TODO: maybe the issue is here
    devise_for :users
    devise_scope :user do
      get 'users/sign_in', to: 'omniauth#new'
      get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    end

  end

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

  # Our TDL resources
  resources :exhibits, only: [] do
    resources :tdl_resources, controller: 'tufts/tdl_resources', only: :create, as: 'tufts_tdl_resources' do
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

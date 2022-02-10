Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do 
    namespace :v1 do
      get 'merchants/find', to: 'merchants#find'
      get 'items/find_all', to: 'items#find_all'

      resources :items do 
        scope module: :items do 
          resources :merchant, only: :index
        end
      end

      resources :merchants, only: [:index, :show] do
        
        scope module: :merchants do 
          resources :items, only: :index
        end
      end 
    end
  end
end

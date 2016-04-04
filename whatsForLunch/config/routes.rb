Rails.application.routes.draw do

  post 'questions/1-2' => "users#first_location_second_restriction", as: :getLocation
  post 'questions/3' => "users#third_mood", as: :questionMood
  post 'questions/4' => "users#fourth_weather", as: :questionWeather
  post 'questions/5' => "users#fifth_spicy", as: :questionSpicy
  post 'questions/6' => "users#sixth_healthy", as: :questionHealthy
  post 'questions/7' => "users#seventh_price", as: :questionPrice
  post 'result' => "users#result", as: :result
  post 'choice_for_today' => "users#choice_for_today", as: :choiceForToday 
  # post 'search' => 'users#search', as: :search
  # get 'result' => "users#show", as: :whatsForLunch

  resources :users

  root 'users#index'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

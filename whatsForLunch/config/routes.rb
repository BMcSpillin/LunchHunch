Rails.application.routes.draw do

  root 'users#index'
  # Questions in partials posting to current user's table
  post 'questions/1' => "users#first_restriction", as: :questionRestriction
  post 'questions/2' => "users#second_mood", as: :questionMood
  post 'questions/3' => "users#third_weather", as: :questionWeather
  post 'questions/4' => "users#fourth_spicy", as: :questionSpicy
  post 'questions/5' => "users#fifth_healthy", as: :questionHealthy
  post 'questions/6' => "users#sixth_price", as: :questionPrice
  # Sum up user details and wrangle location data
  post 'summary' => "users#summary", as: :summary
  post 'choice-for-today' => "users#show", as: :choiceForToday 
  # Results page, which relies on User data
  get 'search' => "users#search", as: :search
  get 'search_again' => "users#search_again", as: :search_again

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

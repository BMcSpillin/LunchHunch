Rails.application.routes.draw do

  post 'questions/getUserLocation' => "questions#getUserLocation", as: :getUserLocation
  post 'questions' => "questions#first_location", as: :getLocation
  post 'questions/2' => "questions#second_allergies", as: :questionAllergies
  post 'questions/3' => "questions#third_mood", as: :questionMood
  post 'questions/4' => "questions#fourth_weather", as: :questionWeather
  post 'questions/5' => "questions#fifth_spicy", as: :questionSpicy
  post 'questions/6' => "questions#sixth_healthy", as: :questionHealthy
  post 'questions/7' => "questions#seventh_price", as: :questionPrice
  post 'choicefortoday' => "questions#result", as: :choiceForToday
  
  resources :users
  resources :questions, defaults: { format: 'js.erb' }


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

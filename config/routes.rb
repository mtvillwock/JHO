Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  root "public#index"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):

  # format: json allows us to not have to specify the format for API requests
  # e.g., http://www.example.com/api/v1/projects.json
  # vs http://www.example.com/api/v1/projects

  # namespace :api, path: '/', constraints: { subdomain: 'api'}, defaults: {format: 'json'} do
  #   namespace :v1 do
  #     resources :sessions, only: [:create]
  #     resources :boards, only: [:show, :index, :create, :update, :destroy]
  #     resources :users, only: [:create, :update, :destroy]
  #     resources :board_members, only: [:create, :update, :destroy]
  #     resources :card_assignments, only: [:create, :update, :destroy]
  #     resources :lists, only: [:create, :update, :destroy]
  #     resources :cards, only: [:create, :update, :destroy] do
  #       resources :movements, only: [:create, :update, :destroy]
  #       resources :tasks, only: [:index, :create, :update, :destroy]
  #     end
  #   end
  # end

  # Refactor to this later
  # with_options only: [:create, :update, :delete] do |list_only|
  #   list_only.resources :board_members
  #   list_only.resources :card_assignments
  #   list_only.resources :cards do
  #     list_only.resources :movements
    # end
  # end

  get '/dashboard' => 'boards#dashboard'

  resources :users, except: [:index, :show, :new, :edit]
  resources :sessions, only: [:create]
  resources :board_members, only: [:create, :update, :destroy]
  resources :card_assignments, only: [:create, :update, :destroy]
  resources :boards, only: [:show, :index, :create, :update, :destroy]
  resources :lists
  # , only: [:create, :update, :destroy]
  resources :cards, only: [:create, :update, :destroy] do
    resources :movements, only: [:create, :update, :destroy]
    resources :tasks, only: [:index, :create, :update, :destroy]
  end



  # resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       ge`````t 'short'
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

#require_relative '../lib/route_scoper'

Rails.application.routes.draw do

  get 'charges/new'

  resources :charges, only: [:new, :create]

  resources :wikis

  #resources :wikis, only: [] do
  #  resources :collaborations, only: [:create]
  #end

 # resources :wikis, only: [] do
 #   resources :collaborations, only:[] do
 #     collection do
 #       delete 'destroy_multiple'
 #     end
 #   end    
 # end

  delete 'wikis/:id/collaborations/destroy_multiple' => 'collaborations#destroy_multiple', as: :d_m_collaborations
  post   'wikis/:id/collaborations/create_multiple' => 'collaborations#create_multiple', as: :c_m_collaborations


  devise_for :users
  resources :users, :only => [:show]

  #resources :users, only: [:show] do
  put 'users/:id/downgrade' => 'users#downgrade', as: :user_downgrade 
  #end  
  #scope RouteScoper.root do
  #get 'welcome/index'

  #get 'welcome/about'

  #authenticated do
  #  root to: "wikis#index", as: :authenticated_root
  #end

   
  get 'about' =>  'welcome#about'

  root 'welcome#index'

  
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
# end
end

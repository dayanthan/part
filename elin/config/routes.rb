Elin::Application.routes.draw do
 # get "pdf/list"
 # get "lien/new"
 # get "user/destroy"
 # get "lien/index"
 get 'reset_password/:reset_password_code' => 'user#resetpassword', :as => :resetpassword, :via => :get  


resource :user
resource :users
resource :lien
resource :pdf
resources :password_resets


#map.connect '', :controller => "lien", :action => "index"
#root :to => "lien#index"
root :to => 'lien#index'

# :to => "users#index"

# # Old style
# map.root :controller => 'home', :action => 'index'

# map.connect ':controller/:action/:id.:format'
# map.connect ':controller/:action/:id'

# # New style
# root :to => 'home#index'

# match '/:controller(/:action(/:id))'


#match '', :controller => "lien", :action =>"index" 


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.



   # match ':controller(.:format)'
    match ':controller(/:action(/:id))'

  # match ':controller(/:action(/:id))(.:format)'
    # map.connect ':controller/:action/:id.:format'
    # map.connect ':controller/:action/:id'
    # root :to => 'ControllerName#Action'
    # map.connect 'products/:id', :controller => 'products', :action => 'view'
    # match 'products/:id', :to => 'catalog#view'
    #match 'controller/:action/:id.:format'
    #match 'controller/:action/:id.'
    # root :to => 'home#index'

    # match '/:controller(/:action(/:id))'  



end

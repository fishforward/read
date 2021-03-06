Weixintui::Application.routes.draw do
  resources :sites

  resources :authentications

  devise_for :users, :controllers => { :omniauth_callbacks => "authentications", :registrations => "read_registrations" } do
    get '/users/sign_out' => 'devise/sessions#destroy'
    get '/users/sign_in' => 'devise/sessions#new'
  end

  resources :sources


  resources :posts

  resources :authors

  match 'wait_audit' => 'sources#wait_audit'
  match 'show_audit/:id' => 'sources#show_audit'

  match 'fetchweixin/:id' => 'home#fetch' 
  match 'home' => 'home#index'
  match 'about' => 'home#about'

  match 'subject/:name' => 'tag#subject'
  match 'tag/:name' => 'tag#show'
  match 'subjects' => 'tag#subjects'
  match '/' => "posts#index"

  match '/sites/read/:id' => 'sites#read'
  match '/sources/audit/:id' => 'sources#audit'

  match 'love' => 'love#create_post'

  ## mobile
  match 'm' => 'home#m'
  match 'subject_m/:name' => 'tag#subject_m'
  match 'tag_m/:name' => 'tag#show_m'
  match 'posts/show_m/:id' => 'posts#show_m'

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
  root :to => 'posts#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

  ## 错误处理 - 区分dev 和 pro
  #match '*path' => proc { |env| Rails.env.development? ? (raise ActionController::RoutingError, %{No route matches "#{env["PATH_INFO"]}"}) : ApplicationController.action(:render_not_found).call(env) }
  match '*path' => proc { |env| ApplicationController.action(:render_not_found).call(env) }

end

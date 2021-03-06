VocabApi::Application.routes.draw do


  namespace :api do
    namespace :v1 do
       get "suras/index" , :defaults => {:format => "json"}
       get "users/cards" , :defaults => {:format => "json"}
       get "users/create_interrogation" , :defaults => {:format => "json"}
       get "users/update_interrogation" , :defaults => {:format => "json"}
       get "users/suras", :defaults => {:format => "json"}
       get "users/cards_by_sura", :defaults => {:format => "json"}
       get "users/statistics_home", :defaults => {:format => "json"}
       get "users/cards_to_work/:sura_id" => 'users#cards_to_work', :defaults => {:format => "json"}
       get "cards/:id" => 'cards#show', :defaults => {:format => "json"}
       post "users/authenticate", :defaults => {:format => "json"}
       post "users/create", :defaults => {:format => "json"}
    end
  end
 
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

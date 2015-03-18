Spree::Core::Engine.routes.append do  
  namespace :admin do
    resources :reports, :only => [:index, :show] do  # <= add this block
      collection do
        get :orders_by_product
        post :orders_by_product
      end
    end
  end
end

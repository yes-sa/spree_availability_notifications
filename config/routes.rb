Spree::Core::Engine.add_routes do
  # Add your extension routes here
  namespace :api, defaults: { format: 'json' } do
    namespace :v3 do
      post '/availability_notifications', to: 'availability_notifications#create', as: :availability_notifications
    end
  end

  namespace :admin do
    resources :availability_notifications
  end
end

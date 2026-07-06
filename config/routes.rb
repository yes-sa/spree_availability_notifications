Spree::Core::Engine.add_routes do
  # Add your extension routes here
  namespace :api, defaults: { format: 'json' } do
    namespace :v3 do
      post '/availability_notification', to: 'availability_notification#create', as: :availability_notification
    end
  end
end

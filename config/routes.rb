require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :members, skip: :sessions

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end

  post "/graphql", to: "graphql#execute"

  post "/easypost-webhook", to: 'orders#webhooks'

  post "/stripe-charge", to: 'payments#charge'

  post "/stripe-source", to: 'payments#source'

  resources :payments, only: [:show], param: :charge
  resources :orders, only: [:show], param: :tracker_id

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_USERNAME'])) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_PASSWORD']))
  end

  mount Sidekiq::Web, at: '/sidekiq'
end

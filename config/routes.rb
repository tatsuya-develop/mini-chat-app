Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "homes#index"

  namespace :api, { format: "json" } do
    namespace :v1 do
      resources :chat_groups
    end
  end
end

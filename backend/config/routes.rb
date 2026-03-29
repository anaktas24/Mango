Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_for :users,
        singular: :user,
        path: "",
        path_names: {
          sign_in: "users/sign_in",
          sign_out: "users/sign_out",
          registration: "users/sign_up"
        },
        controllers: {
          sessions: "api/v1/users/sessions",
          registrations: "api/v1/users/registrations"
        }

      resources :quests, only: [ :index, :show ] do
        resources :steps, only: [ :index ]
      end

      resources :user_quests, only: [ :index, :create ]
      resources :user_steps, only: [ :create ]
    end
  end
end

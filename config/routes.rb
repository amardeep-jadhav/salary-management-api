Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :employees, only: %i[index show create update destroy]
      get "insights/salary", to: "insights#salary"
    end
  end
end

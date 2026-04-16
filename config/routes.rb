Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :employees, only: %i[index show create update destroy]
      get "insights/salary", to: "insights#salary"
      namespace :meta do
        get :countries,   to: "/api/v1/meta#countries"
        get :departments, to: "/api/v1/meta#departments"
        get :job_titles,  to: "/api/v1/meta#job_titles"
      end
    end
  end
end

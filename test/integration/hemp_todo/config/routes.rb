TodoApplication.pot.prepare do
  resources :fellows
  get "/", to: "fellows#index"
end

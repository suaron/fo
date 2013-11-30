Fo::Application.routes.draw do
  resource :home
  resource :signup
  root "signups#new"
end

Rails.application.routes.draw do
  root 'main#index'

  post 'upload', :action => 'upload', :controller => 'main'

  get 'share/:key' => 'main#find'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

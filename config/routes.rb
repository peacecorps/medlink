Rhok::Application.routes.draw do
  root to: 'application#root'
  
  match '/meds', to: 'medrequests#create'

end

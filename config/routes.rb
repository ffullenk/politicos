Politicos::Application.routes.draw do
  root :to => "home#index"
  resources :distritos


  match "/update_distritos" => "home#update_distritos"
   match "/update_circunscripciones" => "home#update_circunscripciones"

   match '/diputados' => 'home#diputados', :as => :diputados
   match '/senadores' => 'home#senadores', :as => :senadores
   match '/home/searchsenadores' => 'home#searchsenadores', :as => :searchsenadores
   match '/home/searchdiputados' => 'home#searchdiputados', :as => :searchdiputados
   match '/home/search' => 'home#search', :as => :search
   match '/home/layers' => 'home#layers', :as => :layers
    match '/home/searchlayers' => 'home#searchlayers', :as => :searchlayers

match '/home/layersdistritos' => 'home#layersdistritos', :as => :layersdistritos
match '/home/layerscircunscripciones' => 'home#layerscircunscripciones', :as => :layerscircunscripciones


end

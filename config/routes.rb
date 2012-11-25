Politicos::Application.routes.draw do
  root :to => "home#index"


  match "/update_distritos" => "home#update_distritos"
   match "/update_circunscripciones" => "home#update_circunscripciones"

   match '/diputados' => 'home#diputados', :as => :diputados
   match '/senadores' => 'home#senadores', :as => :senadores

end

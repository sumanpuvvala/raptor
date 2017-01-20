Rails.application.routes.draw do
  resources :course_links
  resources :subscriptions
  resources :urls
  resources :courses
  resources :interests
  resources :topics
  resources :classifications
  resources :categories
  resources :named_lists
  resources :teammembers
  resources :teams
  resources :members

  match 'courses/:id/copy' => 'courses#copy', :as => :copy_course, via: [:get]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'maintenance', to: :maintenance, controller: 'members'
  get 'help', to: :help, controller: 'members'
  get 'program', to: :program, controller: 'members'
  get 'faq', to: :faq, controller: 'members'
  get 'app', to: :faq, controller: 'members'

  root 'members#index'
end

ActionController::Routing::Routes.draw do |map|

  map.root :controller => "contents", :action => "index"
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.register "register", :controller => "users", :action => "new"

  map.resources :contents, :collection => {:manage => :get}, :member => {:published => :post, :unpublished => :post}

  map.resources :categories

  map.resource :account, :controller => "users"

  map.resources :users, :as => 'members', :member => {:make_admin => :post}

  map.resource :user_session

  map.resources :comments

  map.rpx_login "rpx_login", :controller => 'user_sessions', :action => 'create'
end

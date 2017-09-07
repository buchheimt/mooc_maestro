class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  enable :sessions
  set :session_secret, "learn"

  get '/' do
    erb :index
  end

end

class ApplicationController < Sinatra::Base

  configure do
    enable :sessions
    set :session_secret, "learn"
    set :public_folder, 'public'
    set :views, 'app/views'
  end



  get '/' do
    redirect '/users/login'
  end

  helpers do
    def current_user
      User.find_by_id(session[:user_id])
    end

    def logged_in?
      !!current_user
    end

    def log_out
      session.clear
    end
  end
end

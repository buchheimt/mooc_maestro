class ApplicationController < Sinatra::Base

  use Rack::Flash

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

    def user_created?(topic)
      current_user.id == topic.creator_id
    end

    def name_sort(topics)
      topics.sort {|a,b| a.name <=> b.name}
    end

    def valid_email(email)
      !!email.match(/.+@.+\..+/)
    end

    def valid_name(name)
      !!name.match(/\A[\w ]+\z/)
    end

    def valid_number(string)
      !!string.match(/\A-?\d+\.?\d*?\z/) || string.empty?
    end

    def valid_password(password)
      password.length > 4
    end

    def clean(info)
      info.reject {|k, v| v.empty?}
    end
  end
end

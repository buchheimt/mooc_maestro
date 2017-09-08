class UserController < ApplicationController

  get '/users/login' do
    erb :'users/login'
  end

  post '/users/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/users/homepage'
    else
      redirect '/users/login'
    end
  end

  get '/users/signup' do
    erb :'users/signup'
  end

  post '/users' do
    if params[:student].any? {|k, v| v.empty?}

    else
      @user = User.create(params[:user])

    end

  end

  get '/users/logout' do
    log_out
    redirect '/users/login'
  end

  get '/users/homepage' do
    @user = current_user
    if logged_in?
      erb :'users/homepage'
    else
      redirect '/users/login'
    end
  end

end

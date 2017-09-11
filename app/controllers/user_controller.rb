class UserController < ApplicationController

  get '/users/homepage' do
    @user = current_user
    if logged_in?
      @programs = @user.programs.uniq
      @courses = @user.courses
      erb :'users/homepage'
    else
      flash[:bad] = "Please Log In First"
      redirect '/users/login'
    end
  end

  patch '/users' do
    if logged_in?
      @user = current_user
      params[:course_ids].each do |c_id, v|
        @course = Course.find(c_id.to_i)
        UserCourse.find_on_join(@user, @course).add_progress(v.to_i)
      end
      flash[:good] = "Hours Successfully Added!"
      redirect '/users/homepage'
    else
      flash[:bad] = "Please Log In First"
      redirect '/users/login'
    end
  end

  get '/users/login' do
    if logged_in?
      redirect 'users/homepage'
    else
      erb :'users/login'
    end
  end

  post '/users/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/users/homepage'
    else
      flash[:bad] = "Login Info Was Invalid"
      redirect '/users/login'
    end
  end

  get '/users/signup' do
    erb :'users/signup'
  end

  post '/users' do
    if params[:user].any? {|k, v| v.empty?} || User.find_by(username: params[:user][:username])
      flash[:bad] = "Please Fill Out All Fields"
      redirect '/users/signup'
    else
      @user = User.create(params[:user])
      session[:user_id] = @user.id
      redirect '/users/homepage'
    end
  end

  get '/users/logout' do
    log_out
    redirect '/users/login'
  end
end

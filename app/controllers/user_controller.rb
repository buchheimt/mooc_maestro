class UserController < ApplicationController

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
      redirect '/users/login'
    end
  end

  get '/users/signup' do
    erb :'users/signup'
  end

  post '/users' do
    if params[:user].any? {|k, v| v.empty?} || User.find_by(username: params[:user][:username])
      redirect '/users/signup'
    else
      @user = User.create(params[:user])
      session[:user_id] = @user.id
      redirect '/users/homepage'
    end
  end

  patch '/users' do
    if logged_in?
      @user = current_user
      params[:course_ids].each do |c_id, v|
        @course = Course.find(c_id.to_i)
        @user_course = UserCourse.find_on_join(@user, @course)
        @user_course.progress_in_hours += v.to_i unless v.empty?
        @user_course.save
      end
      redirect '/users/homepage'
    else
      redirect '/users/login'
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

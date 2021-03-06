class UserController < ApplicationController

  get '/users/homepage' do
    @user = current_user
    if logged_in?
      @programs = @user.programs.uniq
      @courses = @user.courses
      erb :'users/homepage'
    else
      flash[:bad] = "Please log in first"
      redirect '/users/login'
    end
  end

  patch '/users' do
    if logged_in?
      case
      when params[:course_ids].values.all? {|v| v.empty?}
        flash[:bad] = "No hours entered"
        redirect '/users/homepage'
      when params[:course_ids].values.any? {|v| !valid_number(v)}
        flash[:bad] = "Enter numbers only"
        redirect '/users/homepage'
      else
        @user = current_user
        params[:course_ids].each do |c_id, v|
          @course = Course.find(c_id)
          @user_course = UserCourse.find_on_join(@user, @course)
          @user_course.add_progress(v.to_i) unless v.empty? || @user_course.nil?
        end
        flash[:good] = "Hours Successfully Added!"
        redirect '/users/homepage'
      end
    else
      flash[:bad] = "Please log in first"
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
      flash[:bad] = "Login info was invalid"
      redirect '/users/login'
    end
  end

  get '/users/signup' do
    erb :'users/signup'
  end

  post '/users' do
    case
    when User.find_by(username: params[:user][:username])
      flash[:bad] = "Username already taken"
      redirect '/users/signup'
    when !valid_name(params[:user][:username])
      flash[:bad] = "Invalid username. Letters, numbers, spaces, and underscores only"
      redirect '/users/signup'
    when !valid_email(params[:user][:email])
      flash[:bad] = "Invalid email"
      redirect '/users/signup'
    when !valid_password(params[:user][:password])
      flash[:bad] = "Password must be at least 5 characters, come on now"
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

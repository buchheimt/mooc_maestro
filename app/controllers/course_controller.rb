class CourseController < ApplicationController

  get '/courses' do
    if logged_in?
      @courses = Course.all.sort {|a,b| a.name <=> b.name}
      erb :'courses/index'
    else
      redirect '/users/login'
    end
  end

  get '/courses/new' do
    if logged_in?
      erb :'courses/new'
    else
      redirect '/users/login'
    end
  end

  post '/courses' do
    if !logged_in? || params[:course][:name].empty? || User.find_by(username: params[:course][:name])
      redirect '/courses/new'
    else
      @user = current_user
      @course = @user.courses.build(params[:course])
      @user.save
      redirect '/users/homepage'
    end
  end

end

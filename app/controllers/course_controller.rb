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
      @programs = Program.all.sort {|a,b| a.name <=> b.name}
      @subjects = Subject.all.sort {|a,b| a.name <=> b.name}

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
      @course = @user.courses.build(name: params[:course][:name])
      @course.description = params[:course][:description] unless params[:course][:description].empty?
      @course.lengh_in_hours = params[:course][:length_in_hours].to_f unless params[:course][:length_in_hours].empty?

      if ! params.include?(:program_id) && params[:program_name].empty?
        @course.program = Program.find_by(name: "Individual Courses")
      elsif params[:program_id].empty?
        @course.program = Program.new(name: params[:program_name])
      else
        @course.program = Program.find_by_id(params[:program_id])
      end

      params[:course][:subject_ids].each do |subject_id|
        @course.subjects << Subject.find_by_id(subject_id)
      end

      @course.subjects << Subject.create(name: params[:subject_name])

      @user.save
      redirect '/users/homepage'
    end
  end

  get '/courses/:slug' do
    @course = Course.find_by_slug(params[:slug])
    if @course && logged_in?
      erb :'courses/show'
    else
      redirect '/users/login'
    end
  end

end

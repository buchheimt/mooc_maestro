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
    if !logged_in? || params[:course][:name].empty? || Course.find_by(name: params[:course][:name])
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
      redirect "/courses/#{@course.slug}"
    end
  end

  get '/courses/:slug/edit' do
    @course = Course.find_by_slug(params[:slug])
    if @course && user_created?(@course)
      @programs = Program.all
      @subjects = Subject.all
      erb :'courses/edit'
    else
      redirect '/courses'
    end
  end

  patch '/courses/:slug' do
    @course = Course.find_by_slug(params[:slug])
    @new_name = params[:course][:name]
    if @course && user_created?(@course) && ! @new_name.empty?
      if @new_name != @course.name && Course.find_by(name: @new_name)
        redirect "/courses/#{@course.slug}/edit"
      else
        @course.name = @new_name
        @course.description = params[:course][:description] unless params[:course][:description].empty?
        @course.length_in_hours = params[:course][:length_in_hours].to_f unless params[:course][:length_in_hours].empty?
        @course.subjects.clear
        params[:course][:subject_ids].each {|s_id| @course.subjects << Subject.find(s_id)}
        @course.program = Program.find(params[:program_id].to_i)

        @course.save
        redirect "/courses/#{@course.slug}"
      end
    else
      redirect "/courses/#{@course.slug}/edit"
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

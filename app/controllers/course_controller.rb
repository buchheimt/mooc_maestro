class CourseController < ApplicationController

  get '/courses' do
    if logged_in?
      @topics = name_sort(Course.all)
      @name = Course.name.downcase
      erb :index
    else
      redirect '/users/login'
    end
  end

  get '/courses/new' do
    if logged_in?
      @programs = name_sort(Program.all.reject {|pr| pr.name == "Individual Courses"})
      @subjects = name_sort(Subject.all)
      erb :'courses/new'
    else
      redirect '/users/login'
    end
  end

  post '/courses' do
    @name = params[:course][:name]
    if !logged_in? || @name.empty? || Course.find_by(name: @name)
      redirect '/courses/new'
    else
      @user = current_user
      @info = params[:course].select {|item| ! item.empty?}
      @course = @user.courses.build(@info)

      if ! params.include?(:program_id) && params[:program_name].empty?
        @course.program = Program.find_by(name: "Individual Courses")
      elsif params[:program_id].empty?
        @course.program = Program.new(name: params[:program_name])
      else
        @course.program = Program.find_by_id(params[:program_id])
      end
      @course.subjects << Subject.create(name: params[:subject_name]) unless params[:subject_name].empty?

      @user.make_creator(@course)
      UserCourse.establish(@user, @course)
      redirect "/courses/#{@course.slug}"
    end
  end

  get '/courses/:slug/edit' do
    @course = Course.find_by_slug(params[:slug])
    if @course && user_created?(@course)
      @programs = name_sort(Program.all)
      @subjects = name_sort(Subject.all)
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
        @info = params[:course].select {|item| ! item.empty?}
        @course.subjects.clear
        @course.update(@info)
        redirect "/courses/#{@course.slug}"
      end
    else
      redirect "/courses/#{@course.slug}/edit"
    end
  end

  get '/courses/:slug/join' do
    @user = current_user
    @course = Course.find_by_slug(params[:slug])
    if @course && logged_in? && ! @user.courses.include?(@course)
      UserCourse.establish(@user, @course)
      redirect "/users/homepage"
    else
      redirect "/courses/#{@course.slug}"
    end
  end

  get '/courses/:slug/leave' do
    @user = current_user
    @course = Course.find_by_slug(params[:slug])
    @user_course = UserCourse.find_on_join(@user, @course)
    if @course && logged_in? && @user_course
      @user_course.delete
      redirect '/users/homepage'
    else
      redirect "/courses/#{@course.slug}"
    end
  end

  get '/courses/:slug' do
    @course = Course.find_by_slug(params[:slug])
    if @course && logged_in?
      @user = current_user
      @user_course = UserCourse.find_on_join(@user, @course)
      erb :'courses/show'
    else
      redirect '/users/login'
    end
  end
end

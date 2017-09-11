class ProgramController < ApplicationController

  get '/programs' do
    if logged_in?
      @topics = name_sort(Program.all.reject {|pr| pr.name == "Individual Courses"})
      @name = Program.name.downcase
      erb :index
    else
      redirect '/users/login'
    end
  end

  get '/programs/new' do
    if logged_in?
      @courses = name_sort(Course.all.select {|c| c.program.name == "Individual Courses"})
      @platforms = name_sort(Platform.all.reject{|pl| pl.name == "Unassigned"})
    else
      redirect '/users/login'
    end
  end

  post '/programs' do
    @name = params[:program][:name]
    if !logged_in? || @name.empty? || Program.find_by(name: @name)
      redirect '/programs/new'
    else
      @user = current_user
      @info = params[:program].select {|item| ! item.empty?}
      @program = Program.new(@info)
      if ! params.include?(:platform_id) && params[:platform_name].empty?
        @program.platform = Platform.new(name: "Unassigned")
      elsif params[:platform_id].empty?
        @program.platform = Platform.new(name: params[:platform_name])
      else
        @program.platform = Platform.find_by_id(params[:platform_id])
      end
      @user.make_creator(@program)
      redirect "/programs/#{@program.slug}"
    end
  end

  get '/programs/:slug/edit' do
    @program = Program.find_by_slug(params[:slug])
    if @program && user_created?(@program)
      @platforms = name_sort(Platform.all.reject {|pl| pl.name == "Unassigned"})
      @courses = name_sort(Course.all.select {|c| c.program.name == "Individual Courses" || c.program == @program})
      erb :'programs/edit'
    else
      redirect '/programs'
    end
  end

  patch '/programs/:slug' do
    @program = Program.find_by_slug(params[:slug])
    @new_name = params[:program][:name]
    if @program && user_created?(@program) && ! @new_name.empty?
      if @new_name != @program.name && Program.find_by(name: @new_name)
        redirect "/programs/#{@program.slug}/edit"
      else
        @info = params[:program].select {|item| ! item.empty?}
        @program.courses.clear
        @program.update(@info)
        Course.all.select {|c| c.program_id == nil}.each do |c|
          c.program = Program.find_by(name: "Individual Courses")
          c.save
        end
        redirect "/programs/#{@program.slug}"
      end
    else
      redirect "/programs/#{@program.slug}/edit"
    end
  end

  get '/programs/:slug/join' do
    @user = current_user
    @program = Program.find_by_slug(params[:slug])
    if @program && logged_in?
      @program.courses.each do |course|
        UserCourse.establish(@user, course) unless @user.courses.include?(course)
      end
      redirect "/users/homepage"
    else
      redirect "/programs/#{@program.slug}"
    end
  end

  get '/programs/:slug/leave' do
    @user = current_user
    @program = Program.find_by_slug(params[:slug])
    if @program && logged_in? && @user.programs.include?(@program)
      @program.courses.each do |course|
        @user_course = UserCourse.find_on_join(@user, course)
        @user_course.delete if @user_course
      end
      redirect '/users/homepage'
    else
      redirect "/programs/#{@program.slug}"
    end
  end

  get '/programs/:slug' do
    @program = Program.find_by_slug(params[:slug])
    if @program && logged_in?
      @user = current_user
      erb :'programs/show'
    else
      redirect '/users/login'
    end
  end

end

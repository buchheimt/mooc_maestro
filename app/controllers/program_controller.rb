class ProgramController < ApplicationController

  get '/programs' do
    if logged_in?
      @topics = name_sort(Program.all.reject {|pr| pr.name == "Individual Courses"})
      @name = Program.name.downcase
      erb :index
    else
      flash[:bad] = "Please log in first"
      redirect '/users/login'
    end
  end

  get '/programs/new' do
    if logged_in?
      @courses = name_sort(Course.all.select {|c| c.program.name == "Individual Courses"})
      @platforms = name_sort(Platform.all.reject{|pl| pl.name == "Unassigned"})
      erb :'programs/new'
    else
      flash[:bad] = "Please log in first"
      redirect '/users/login'
    end
  end

  post '/programs' do
    @name = params[:program][:name]
    if logged_in?
      case
      when Program.find_by(name: @name)
        flash[:bad] = "Program name already taken"
        redirect '/programs/new'
      when !valid_name(@name)
        flash[:bad] = "Invalid name. Letters, numbers, spaces, and underscores only"
        redirect '/programs/new'
      when !valid_number(params[:program][:cost]) || params[:program][:cost].to_f < 0
        flash[:bad] = "Enter only numbers for Cost, or leave it blank"
        redirect '/programs/new'
      else
        @user = current_user
        @info = params[:program].select {|item| ! item.empty?}
        @program = Program.new(@info)
        if ! params.include?(:platform_id) && params[:platform_name].empty?
          @platform = Platform.new(name: "Unassigned")
        elsif params[:platform_id].empty?
          @platform = Platform.new(name: params[:platform_name])
        else
          @platform = Platform.find_by_id(params[:platform_id])
        end
        @program.platform = @platform
        @user.make_creator(@platform)
        @user.make_creator(@program)

        flash[:good] = "Program created!"
        redirect "/programs/#{@program.slug}"
      end
    else
      flash[:bad] = "Please log in first"
      redirect '/users/login'
    end
  end

  get '/programs/:slug/edit' do
    @program = Program.find_by_slug(params[:slug])
    if @program && user_created?(@program)
      @platforms = name_sort(Platform.all.reject {|pl| pl.name == "Unassigned"})
      @courses = name_sort(Course.all.select {|c| c.program.name == "Individual Courses" || c.program == @program})
      erb :'programs/edit'
    else
      flash[:bad] = "You must create a program to edit or delete it"
      redirect '/programs'
    end
  end

  patch '/programs/:slug' do
    @program = Program.find_by_slug(params[:slug])
    @new_name = params[:program][:name]
    case
    when !@program || !user_created?(@program)
      flash[:bad] = "You must create a program to edit or delete it"
      redirect "/programs/#{@program.slug}"
    when @new_name != @program.name && Program.find_by(name: @new_name)
      flash[:bad] = "Program name entered is already taken"
      redirect "/programs/#{@program.slug}/edit"
    when !valid_name(@new_name)
      flash[:bad] = "Invalid name. Letters, numbers, spaces, and underscores only"
      redirect "/programs/#{@program.slug}/edit"
    when !valid_number(params[:program][:cost]) || params[:program][:cost].to_f < 0
      flash[:bad] = "Enter only numbers for Cost, or leave it blank"
      redirect "/programs/#{@program.slug}/edit"
    else
      @info = params[:program].select {|item| ! item.empty?}
      @program.courses.clear
      @program.update(@info)
      Course.all.select {|c| c.program_id == nil}.each do |c|
        c.program = Program.find_by(name: "Individual Courses")
        c.save
      end
      flash[:good] = "Program successfully edited"
      redirect "/programs/#{@program.slug}"
    end
  end

  get '/programs/:slug/delete' do
    @user = current_user
    @program = Program.find_by_slug(params[:slug])
    if @program && user_created?(@program)
      @program.destroy
      flash[:good] = "Program successfully deleted"
    else
      flash[:bad] = "You must create a program to delete it"
    end
    redirect '/programs'
  end

  get '/programs/:slug/join' do
    @user = current_user
    @program = Program.find_by_slug(params[:slug])
    if @program && logged_in?
      @program.courses.each do |course|
        UserCourse.establish(@user, course) unless @user.courses.include?(course)
      end
      flash[:good] = "Program successfully joined!"
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
      flash[:good] = "Program Successfully Removed"
      redirect '/users/homepage'
    else
      flash[:bad] = "You cannot leave a program you haven't joined"
      redirect "/programs/#{@program.slug}"
    end
  end

  get '/programs/:slug' do
    @program = Program.find_by_slug(params[:slug])
    if @program && logged_in?
      @user = current_user
      erb :'programs/show'
    else
      flash[:bad] = "Program not found"
      redirect '/programs'
    end
  end
end

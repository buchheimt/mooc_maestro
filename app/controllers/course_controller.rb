class CourseController < ApplicationController

  get '/courses' do
    if logged_in?
      @topics = name_sort(Course.all)
      @name = Course.name.downcase
      erb :index
    else
      flash[:bad] = "Please log in first"
      redirect '/users/login'
    end
  end

  get '/courses/new' do
    if logged_in?
      @programs = name_sort(Program.all.reject {|pr| pr.name == "Individual Courses"})
      @subjects = name_sort(Subject.all)
      erb :'courses/new'
    else
      flash[:bad] = "Please log in first"
      redirect '/users/login'
    end
  end

  post '/courses' do
    @name = params[:course][:name]
    if logged_in?
      case
      when Course.find_by(name: @name)
        flash[:bad] = "Course name already taken"
        redirect '/courses/new'
      when !valid_name(@name)
        flash[:bad] = "Invalid name. Letters, numbers, spaces, and underscores only"
        redirect '/courses/new'
      when !valid_number(params[:course][:length_in_hours]) || params[:course][:length_in_hours].to_f < 0
        flash[:bad] = "Enter only numbers for Course Length, or leave it blank"
        redirect '/courses/new'
      else
        @user = current_user
        @info = params[:course].reject {|k, v| v.empty?}
        @course = @user.courses.build(@info)

        if !params.include?(:program_id) && params[:program_name].empty?
          @program = Program.find_by(name: "Individual Courses")
        elsif params[:program_id].empty?
          @program = Program.new(name: params[:program_name])
          @program.platform = Platform.find_by(name: "Unassigned")
        else
          @program = Program.find_by_id(params[:program_id])
        end

        @course.subjects << Subject.create(name: params[:subject_name]) unless params[:subject_name].empty?
        @course.program = @program
        @user.make_creator(@program)
        @user.make_creator(@course)
        UserCourse.establish(@user, @course)

        flash[:good] = "Course created!"
        redirect "/courses/#{@course.slug}"
      end
    else
      flash[:bad] = "Please log in first"
      redirect '/users/login'
    end
  end

  get '/courses/:slug/edit' do
    @course = Course.find_by_slug(params[:slug])
    if @course && user_created?(@course)
      @programs = name_sort(Program.all)
      @subjects = name_sort(Subject.all)
      erb :'courses/edit'
    else
      flash[:bad] = "You must create a course to edit or delete it"
      redirect '/courses'
    end
  end

  patch '/courses/:slug' do
    @course = Course.find_by_slug(params[:slug])
    @new_name = params[:course][:name]
    case
    when !@course || !user_created?(@course)
      flash[:bad] = "You must create a course to edit or delete it"
      redirect "/courses/#{@course.slug}"
    when @new_name != @course.name && Course.find_by(name: @new_name)
      flash[:bad] = "Course name entered is already taken"
      redirect "/courses/#{@course.slug}/edit"
    when !valid_name(@new_name)
      flash[:bad] = "Invalid name. Letters, numbers, spaces, and underscores only"
      redirect "/courses/#{@course.slug}/edit"
    when !valid_number(params[:course][:length_in_hours]) || params[:course][:length_in_hours].to_f < 0
      flash[:bad] = "Enter only numbers for Course Length, or leave it blank"
      redirect "/courses/#{@course.slug}/edit"
    else
      @info = params[:course].reject {|k, v| v.empty?}
      @course.subjects.clear
      @course.update(@info)
      flash[:good] = "Course successfully edited"
      redirect "/courses/#{@course.slug}"
    end
  end

  get '/courses/:slug/delete' do
    @user = current_user
    @course = Course.find_by_slug(params[:slug])
    if @course && user_created?(@course)
      @course.destroy
      flash[:good] = "Course successfully deleted"
    else
      flash[:bad] = "You must create a course to delete it"
    end
    redirect '/courses'
  end

  get '/courses/:slug/join' do
    @user = current_user
    @course = Course.find_by_slug(params[:slug])
    if @course && logged_in? && ! @user.courses.include?(@course)
      UserCourse.establish(@user, @course)
      flash[:good] = "Course successfully joined!"
      redirect "/users/homepage"
    else
      flash[:bad] = "You have already joined this course"
      redirect "/courses/#{@course.slug}"
    end
  end

  get '/courses/:slug/leave' do
    @user = current_user
    @course = Course.find_by_slug(params[:slug])
    @user_course = UserCourse.find_on_join(@user, @course)
    if @course && logged_in? && @user_course
      @user_course.delete
      flash[:good] = "Course successfully removed"
      redirect '/users/homepage'
    else
      flash[:bad] = "You cannot leave a course you haven't joined"
      redirect "/courses/#{@course.slug}"
    end
  end

  get '/courses/:slug' do
    @course = Course.find_by_slug(params[:slug])
    if @course && logged_in?
      @user = current_user
      @user_course = UserCourse.find_on_join(@user, @course)
      @length = @course.get_length
      @program = @course.program.if_assigned
      @platform = @course.platform.if_assigned
      @subjects = name_sort(@course.subjects)
      erb :'courses/show'
    else
      flash[:bad] = "Course not found"
      redirect '/courses'
    end
  end
end

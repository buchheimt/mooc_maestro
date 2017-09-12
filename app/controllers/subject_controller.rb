class SubjectController < ApplicationController

  get '/subjects' do
    if logged_in?
      @topics = name_sort(Subject.all)
      @name = Subject.name.downcase
      erb :index
    else
      flash[:bad] = "Please log in first"
      redirect '/users/login'
    end
  end

  get '/subjects/new' do
    if logged_in?
      @courses = name_sort(Course.all)
      erb :'subjects/new'
    else
      flash[:bad] = "Please log in first"
      redirect '/users/login'
    end
  end

  post '/subjects' do
    @name = params[:subject][:name]
    if logged_in?
      case
      when Subject.find_by(name: @name)
        flash[:bad] = "Subject name already taken"
        redirect '/subjects/new'
      when !valid_name(@name)
        flash[:bad] = "Invalid name. Letters, numbers, spaces, and underscores only"
        redirect '/subjects/new'
      else
        @user = current_user
        @info = params[:subject].select {|item| ! item.empty?}
        @subject = Subject.new(@info)
        @user.make_creator(@subject)
        flash[:good] = "Subject created!"
        redirect "/subjects/#{@subject.slug}"
      end
    else
      flash[:bad] = "Please log in first"
      redirect '/users/login'
    end
  end

  get '/subjects/:slug/edit' do
    @subject = Subject.find_by_slug(params[:slug])
    if @subject && user_created?(@subject)
      @courses = name_sort(Course.all)
      erb :'subjects/edit'
    else
      flash[:bad] = "You must create a subject to edit or delete it"
      redirect '/subjects'
    end
  end

  patch '/subjects/:slug' do
    @subject = Subject.find_by_slug(params[:slug])
    @new_name = params[:subject][:name]
    case
    when !@subject || !user_created?(@subject)
      flash[:bad] = "You must create a subject to edit or delete it"
      redirect "/subjects/#{@subject.slug}"
    when @new_name != @subject.name && Subject.find_by(name: @new_name)
      flash[:bad] = "Subject name entered is already taken"
      redirect "/subjects/#{@subject.slug}/edit"
    when !valid_name(@new_name)
      flash[:bad] = "Invalid name. Letters, numbers, spaces, and underscores only"
      redirect "/subjects/#{@subject.slug}/edit"
    else
      @subject.courses.clear
      @info = params[:subject].select {|item| ! item.empty?}
      @subject.update(@info)
      flash[:good] = "Subject successfully edited"
      redirect "/subjects/#{@subject.slug}"
    end
  end

  get '/subjects/:slug/delete' do
    @user = current_user
    @subject = Subject.find_by_slug(params[:slug])
    if @subject && user_created?(@subject)
      @subject.destroy
      flash[:good] = "Subject successfully deleted"
    else
      flash[:bad] = "You must create a subject to delete it"
    end
  end

  get '/subjects/:slug' do
    @subject = Subject.find_by_slug(params[:slug])
    if @subject && logged_in?
      erb :'subjects/show'
    else
      flash[:bad] = "Subject not found"
      redirect '/subjects'
    end
  end
end

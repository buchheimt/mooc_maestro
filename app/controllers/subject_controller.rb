class SubjectController < ApplicationController

  get '/subjects' do
    if logged_in?
      @topics = name_sort(Subject.all)
      @name = Subject.name.downcase
      erb :index
    else
      flash[:bad] = "Please Log In First"
      redirect '/users/login'
    end
  end

  get '/subjects/new' do
    if logged_in?
      @courses = name_sort(Course.all)
      erb :'subjects/new'
    else
      flash[:bad] = "Please Log In First"
      redirect '/users/login'
    end
  end

  post '/subjects' do
    @name = params[:subject][:name]
    if !logged_in? || @name.empty? || Subject.find_by(name: @name)
      flash[:bad] = "Bad input, Make sure name is unique"
      redirect '/subjects/new'
    else
      @user = current_user
      @info = params[:subject].select {|item| ! item.empty?}
      @subject = Subject.new(@info)
      @user.make_creator(@subject)
      flash[:good] = "Subject Created!"
      redirect "/subjects/#{@subject.slug}"
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
    if @subject && user_created?(@subject) && ! @new_name.empty?
      if @new_name != @subject.name && Subject.find_by(name: @new_name)
        flash[:bad] = "Name entered is already taken"
        redirect "/subjects/#{@subject.slug}/edit"
      else
        @subject.courses.clear
        @info = params[:subject].select {|item| ! item.empty?}
        @subject.update(@info)

        flash[:good] = "Subject successfully edited"
        redirect "/subjects/#{@subject.slug}"
      end
    else
      flash[:bad] = "Something went wrong, please try again"
      redirect "/subjects/#{@subject.slug}/edit"
    end
  end

  get '/subjects/:slug/delete' do
    @user = current_user
    @subject = Subject.find_by_slug(params[:slug])
    if @subject && user_created?(@subject)
      @subject.destroy
      flash[:bad] = "Subject Successfully Deleted"
      redirect '/subjects'
    end
  end

  get '/subjects/:slug' do
    @subject = Subject.find_by_slug(params[:slug])
    if @subject && logged_in?
      erb :'subjects/show'
    else
      flash[:bad] = "Please log in to view subjects"
      redirect '/users/login'
    end
  end
end

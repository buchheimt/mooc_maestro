class SubjectController < ApplicationController

  get '/subjects' do
    if logged_in?
      @topics = name_sort(Subject.all)
      @name = name_sort(Subject.name.downcase)
      erb :index
    else
      redirect '/users/login'
    end
  end

  get '/subjects/new' do
    if logged_in?
      @courses = name_sort(Course.all)
      erb :'subjects/new'
    else
      redirect '/users/login'
    end
  end

  post '/subjects' do
    @name = params[:subject][:name]
    if !logged_in? || @name.empty? || Subject.find_by(name: @name)
      redirect '/subjects/new'
    else
      @user = current_user
      @info = params[:subject].select {|item| ! item.empty?}
      @subject = Subject.new(@info)
      @user.make_creator(@subject)
      redirect "/subjects/#{@subject.slug}"
    end
  end

  get '/subjects/:slug/edit' do
    @subject = Subject.find_by_slug(params[:slug])
    if @subject && user_created?(@subject)
      @courses = name_sort(Course.all)
      erb :'subjects/edit'
    else
      redirect '/subjects'
    end
  end

  patch '/subjects/:slug' do
    @subject = Subject.find_by_slug(params[:slug])
    @new_name = params[:subject][:name]
    if @subject && user_created?(@subject) && ! @new_name.empty?
      if @new_name != @subject.name && Subject.find_by(name: @new_name)
        redirect "/subjects/#{@subject.slug}/edit"
      else
        @subject.courses.clear
        @info = params[:subject].select {|item| ! item.empty?}
        @subject.update(@info)
        redirect "/subjects/#{@subject.slug}"
      end
    else
      redirect "/subjects/#{@subject.slug}/edit"
    end
  end

  get '/subjects/:slug' do
    @subject = Subject.find_by_slug(params[:slug])
    if @subject && logged_in?
      erb :'subjects/show'
    else
      redirect '/users/login'
    end
  end
end

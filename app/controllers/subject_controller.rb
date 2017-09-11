class SubjectController < ApplicationController

  get '/subjects' do
    if logged_in?
      @topics = Subject.all.sort {|a,b| a.name <=> b.name}
      @name = Subject.name.downcase
      erb :index
    else
      redirect '/users/login'
    end
  end

  get '/subjects/new' do
    if logged_in?
      @courses = Course.all.sort {|a,b| a.name <=> b.name}
      erb :'subjects/new'
    else
      redirect '/users/login'
    end
  end

  post '/subjects' do
    @user = current_user
    @name = params[:subject][:name]
    if !logged_in? || @name.empty? || Subject.find_by(name: @name)
      redirect '/subjects/new'
    else
      @info = params[:subject].select {|item| ! item.empty?}
      @subject = Subject.new(@info)
      @subject.creator_id = @user.id
      @subject.save
      redirect "/subjects/#{@subject.slug}"
    end
  end

  get '/subjects/:slug/edit' do
    @subject = Subject.find_by_slug(params[:slug])
    if @subject && user_created?(@subject)
      @courses = Course.all
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
        @subject.name = @new_name
        @subject.description = params[:subject][:description] unless params[:subject][:description].empty?
        @subject.courses.clear
        params[:subject][:course_ids].each {|c_id| @subject.courses << Course.find(c_id)}
        @subject.save
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

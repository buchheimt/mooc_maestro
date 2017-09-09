class SubjectController < ApplicationController

  get '/subjects' do
    if logged_in?
      @subjects = Subject.all.sort {|a,b| a.name <=> b.name}
      erb :'subjects/index'
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

  get '/subjects/:slug' do
    @subject = Subject.find_by_slug(params[:slug])
    if @subject && logged_in?
      erb :'subjects/show'
    else
      redirect '/users/login'
    end
  end

end

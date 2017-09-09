class PlatformController < ApplicationController

  get '/platforms' do
    if logged_in?
      @platforms = Platform.all.sort {|a,b| a.name <=> b.name}
      erb :'platforms/index'
    else
      redirect '/users/login'
    end
  end

  get '/programs/new' do
    if logged_in?
      @programs = Program.all.select {|pr| pr.platform.name == "Unassigned"}.sort {|a,b| a.name <=> b.name}

      erb :'programs/new'
    else
      redirect '/users/login'
    end
  end

end

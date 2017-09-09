class PlatformController < ApplicationController

  get '/platforms' do
    if logged_in?
      @platforms = Platform.all.sort {|a,b| a.name <=> b.name}
      erb :'platforms/index'
    else
      redirect '/users/login'
    end
  end

  get '/platforms/new' do
    if logged_in?
      @programs = Program.all.select do |pr|
        pr.platform.name == "Unassigned" && pr.name != "Individual Courses"
      end.sort {|a,b| a.name <=> b.name}

      erb :'platforms/new'
    else
      redirect '/users/login'
    end
  end

end

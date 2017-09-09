class ProgramController < ApplicationController

  get '/programs' do
    if logged_in?
      @programs = Program.all.sort {|a,b| a.name <=> b.name}
      erb :'programs/index'
    else
      redirect '/users/login'
    end
  end

  get '/programs/:slug' do
    @program = Program.find_by_slug(params[:slug])
    if @program && logged_in?
      erb :'programs/show'
    else
      redirect '/users/login'
    end
  end

end

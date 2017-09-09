class ProgramController < ApplicationController

  get '/programs' do
    if logged_in?
      @programs = Program.all.sort {|a,b| a.name <=> b.name}
      erb :'programs/index'
    else
      redirect '/users/login'
    end
  end

end

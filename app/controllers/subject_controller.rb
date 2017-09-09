class SubjectController < ApplicationController

  get '/subjects' do
    if logged_in?
      @subjects = Subject.all.sort {|a,b| a.name <=> b.name}
      erb :'subjects/index'
    else
      redirect '/users/login'
    end
  end

end

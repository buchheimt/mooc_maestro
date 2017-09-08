class CourseController < ApplicationController

  get '/courses' do
    @courses = Course.all.sort {|a,b| a.name <=> b.name}
    erb :'courses/index'
  end

end

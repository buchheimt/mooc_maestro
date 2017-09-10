class ProgramController < ApplicationController

  get '/programs' do
    if logged_in?
      @programs = Program.all.reject {|pr| pr.name == "Individual Courses"}.sort {|a,b| a.name <=> b.name}
      erb :'programs/index'
    else
      redirect '/users/login'
    end
  end

  get '/programs/new' do
    if logged_in?
      @courses = Course.all.select {|c| c.program.name == "Individual Courses"}.sort {|a,b| a.name <=> b.name}
      @platforms = Platform.all.sort {|a,b| a.name <=> b.name}

      erb :'programs/new'
    else
      redirect '/users/login'
    end
  end

  post '/programs' do
    if !logged_in? || params[:program][:name].empty? || Program.find_by(name: params[:program][:name])
      redirect '/programs/new'
    else
      @program = Program.new(name: params[:program][:name])
      @program.description = params[:program][:description] unless params[:program][:description].empty?
      @program.certification = params[:program][:certification] unless params[:program][:certification].empty?
      @program.cost = params[:program][:cost].to_f unless params[:program][:cost].empty?
      @program.affiliation = params[:program][:affiliation] unless params[:program][:affiliation].empty?

      if ! params.include?(:platform_id) && params[:platform_name].empty?
        @program.platform = Platform.new(name: "Unassigned")
      elsif params[:platform_id].empty?
        @program.platform = Platform.new(name: params[:platform_name])
      else
        @program.platform = Platform.find_by_id(params[:platform_id])
      end

      params[:program][:course_ids].each do |course_id|
        @program.courses << Course.find(course_id)
      end

      @program.save
      redirect "/programs/#{@program.slug}"
    end
  end

  get '/programs/:slug/edit' do
    @program = Program.find_by_slug(params[:slug])
    if @program && user_created?(@program)
      @platforms = Platform.all.reject {|pl| pl.name == "Unassigned"}
      @courses = Course.all.select {|c| c.program.name == "Individual Courses" || c.program == @program}
      erb :'programs/edit'
    else
      redirect '/programs'
    end
  end

  patch '/programs/:slug' do
    @program = Program.find_by_slug(params[:slug])
    @new_name = params[:program][:name]
    if @program && user_created?(@program) && ! @new_name.empty?
      if @new_name != @program.name && Program.find_by(name: @new_name)
        redirect "/programs/#{@program.slug}/edit"
      else
        @program.name = @new_name
        @program.description = params[:program][:description] unless params[:program][:description].empty?
        @program.courses.clear
        params[:program][:course_ids].each {|c_id| @program.courses << Course.find(c_id)}
        Course.all.select {|c| c.program_id == nil}.each do |c|
          c.program = Program.find_by(name: "Individual Courses")
          c.save
        end
        @program.save
        redirect "/programs/#{@program.slug}"
      end
    else
      redirect "/programs/#{@program.slug}/edit"
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

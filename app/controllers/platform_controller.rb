class PlatformController < ApplicationController

  get '/platforms' do
    if logged_in?
      @platforms = Platform.all.reject {|pl| pl.name == "Unassigned"}.sort {|a,b| a.name <=> b.name}
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

  post '/platforms' do
    if !logged_in? || params[:platform][:name].empty? || Platform.find_by(name: params[:platform][:name])
      redirect '/platforms/new'
    else
      @platform = Platform.new(name: params[:platform][:name])
      @platform.description = params[:platform][:description] unless params[:platform][:description].empty?

      if params[:platform].include?(:program_ids)
        params[:platform][:program_ids].each do |program_id|
          @platform.programs << Program.find(program_id)
        end
      end

      @platform.save
      redirect "/platforms/#{@platform.slug}"
    end
  end

  get '/platforms/:slug/edit' do
    @platform = Platform.find_by_slug(params[:slug])
    if @platform && user_created?(@platform)
      @programs = Program.all.select {|pr| pr.name == "Unassigned" || pr.platform == @platform}
      erb :'platforms/edit'
    else
      redirect '/platforms'
    end
  end

  patch '/platforms/:slug' do
    @platform = Platform.find_by_slug(params[:slug])
    @new_name = params[:platform][:name]
    if @platform && user_created?(@platform) && ! @new_name.empty?
      if @new_name != @platform.name && Platform.find_by(name: @new_name)
        redirect '/platforms/<%= @platform.slug %>/edit'
      else
        @platform.name = @new_name
        @platform.description = params[:platform][:description] unless params[:platform][:description].empty?
        @platform.programs.clear
        params[:platform][:program_ids].each {|pr_id| @platform.programs << Program.find(pr_id)}
        @platform.save
        redirect "/platforms/#{@platform.slug}"
      end
    else
      redirect '/platforms/<%= @platform.slug %>/edit'
    end
  end

  get '/platforms/:slug' do
    @platform = Platform.find_by_slug(params[:slug])
    if @platform && logged_in?
      erb :'platforms/show'
    else
      redirect '/users/login'
    end
  end

end
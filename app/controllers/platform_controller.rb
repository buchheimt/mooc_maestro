class PlatformController < ApplicationController

  get '/platforms' do
    if logged_in?
      @topics = name_sort(Platform.all.reject {|pl| pl.name == "Unassigned"})
      @name = Platform.name.downcase
      erb :index
    else
      redirect '/users/login'
    end
  end

  get '/platforms/new' do
    if logged_in?
      @programs = Program.all.select {|pr| pr.platform.name == "Unassigned" && pr.name != "Individual Courses"}
      @programs = name_sort(@programs)
      erb :'platforms/new'
    else
      redirect '/users/login'
    end
  end

  post '/platforms' do
    @name = params[:platform][:name]
    if !logged_in? || @name.empty? || Platform.find_by(name: @name)
      redirect '/platforms/new'
    else
      @user = current_user
      @info = params[:platform].select {|item| ! item.empty?}
      @platform = Platform.new(@info)
      @user.make_creator(@platform)
      redirect "/platforms/#{@platform.slug}"
    end
  end

  get '/platforms/:slug/edit' do
    @platform = Platform.find_by_slug(params[:slug])
    if @platform && user_created?(@platform)
      @programs = Program.all.select do |pr|
        pr.platform.name == "Unassigned" || pr.platform == @platform
      end.reject {|pr| pr.name == "Individual Courses"}
      @programs = name_sort(@programs)
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
        redirect "/platforms/#{@platform.slug}/edit"
      else
        @platform.programs.clear
        @info = params[:platform].select {|item| ! item.empty?}
        @platform.update(@info)

        Program.all.select {|pr| pr.platform_id == nil}.each do |pr|
          pr.platform = Platform.find_by(name: "Unassigned")
          pr.save
        end

        redirect "/platforms/#{@platform.slug}"
      end
    else
      redirect "/platforms/#{@platform.slug}/edit"
    end
  end

  get '/platforms/:slug/delete' do
    @user = current_user
    @platform = Platform.find_by_slug(params[:slug])
    if @platform && user_created?(@platform)
      @platform.destroy
      redirect '/platforms'
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

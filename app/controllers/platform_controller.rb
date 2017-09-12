class PlatformController < ApplicationController

  get '/platforms' do
    if logged_in?
      @topics = name_sort(Platform.all.reject {|pl| pl.name == "Unassigned"})
      @name = Platform.name.downcase
      erb :index
    else
      flash[:bad] = "Please log in first"
      redirect '/users/login'
    end
  end

  get '/platforms/new' do
    if logged_in?
      @programs = Program.all.select {|pr| pr.platform.name == "Unassigned" && pr.name != "Individual Courses"}
      @programs = name_sort(@programs)
      erb :'platforms/new'
    else
      flash[:bad] = "Please log in first"
      redirect '/users/login'
    end
  end

  post '/platforms' do
    @name = params[:platform][:name]
    if !logged_in? || Platform.find_by(name: @name)
      flash[:bad] = "Platform name already taken"
      redirect '/platforms/new'
    else
      @user = current_user
      @info = params[:platform].select {|item| ! item.empty?}
      @platform = Platform.new(@info)
      @user.make_creator(@platform)
      flash[:good] = "Platform created!"
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
      flash[:bad] = "You must create a platform to edit or delete it"
      redirect '/platforms'
    end
  end

  patch '/platforms/:slug' do
    @platform = Platform.find_by_slug(params[:slug])
    @new_name = params[:platform][:name]
    if @platform && user_created?(@platform)
      if @new_name != @platform.name && Platform.find_by(name: @new_name)
        flash[:bad] = "Platform name entered is already taken"
        redirect "/platforms/#{@platform.slug}/edit"
      else
        @platform.programs.clear
        @info = params[:platform].select {|item| ! item.empty?}
        @platform.update(@info)

        Program.all.select {|pr| pr.platform_id == nil}.each do |pr|
          pr.platform = Platform.find_by(name: "Unassigned")
          pr.save
        end

        flash[:good] = "Platform successfully edited"
        redirect "/platforms/#{@platform.slug}"
      end
    else
      flash[:bad] = "You must create a platform to edit or delete it"
      redirect "/platforms/#{@platform.slug}"
    end
  end

  get '/platforms/:slug/delete' do
    @user = current_user
    @platform = Platform.find_by_slug(params[:slug])
    if @platform && user_created?(@platform)
      @platform.destroy
      flash[:good] = "Platform successfully deleted"
    else
      flash[:bad] = "You must create a platform to delete it"
    end
    redirect '/platforms'
  end

  get '/platforms/:slug' do
    @platform = Platform.find_by_slug(params[:slug])
    if @platform && logged_in?
      erb :'platforms/show'
    else
      flash[:bad] = "Program not found"
      redirect '/platforms'
    end
  end
end

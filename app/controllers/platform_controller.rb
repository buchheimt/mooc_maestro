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
          @platform.courses << Program.find(program_id)
        end
      end

      @platform.save
      redirect "/platforms/#{@platform.slug}"
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

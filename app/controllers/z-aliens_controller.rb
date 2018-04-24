class AliensController < ApplicationController

  get "/aliens" do
    if logged_in?
      @aliens = current_user.aliens
      erb :'aliens/index'
    else
      redirect to "/"
    end
  end

  get "/aliens/new" do
    if logged_in?
      erb :'aliens/create_alien'
    else redirect to "/"
    end
  end

  get "/aliens/:slug" do
    if logged_in?
      @alien = Alien.find_by_slug(params[:slug])
      erb :'aliens/show_alien'
    else redirect to "/"
    end
  end

  get "/aliens/:slug/edit" do
    if logged_in?
      @alien = Alien.find_by_slug(params[:slug])
      erb :'aliens/edit_alien'
    else redirect to "/"
    end
  end

  patch "/aliens/:slug" do
    if logged_in?
      if !name.empty? && !classification.empty? && !description.empty?
        @alien = Alien.find_by_slug(params[:slug])
        @alien.update(name: name, classification: classification, description: description)
        @alien.save
        redirect to "/aliens/#{@alien.slug}"
      else
        flash[:message] = "*Please fill out all fields"
      end
      @alien = Alien.find_by_slug(params[:slug])
      redirect to "/aliens/#{@alien.slug}/edit"
    else redirect to "/"
    end
  end

  post "/aliens" do
    if logged_in?
      if !name.empty? && !classification.empty? && !description.empty?
        @alien = Alien.create(name: params[:name], classification: params[:classification], description: params[:description])
        @planet = Planet.find_or_create_by(name: params[:planet], user_id: user_id)
        @alien.planet_id = @planet.id
        @alien.save
        redirect to "/aliens/#{@alien.slug}"
      else
        flash[:message] = "*Please fill out all fields"
      end
      redirect to "/aliens/new"
    else redirect to "/"
    end
  end

  delete "/aliens/:slug" do
    if logged_in?
      @alien = Alien.find_by_slug(params[:slug])
      @alien.delete
      redirect to "/profile"
    else redirect to "/"
    end
  end

end

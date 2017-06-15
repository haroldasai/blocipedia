class WikisController < ApplicationController
  def index
  	#@wikis = Wiki.all
    @wikis = policy_scope(Wiki)
  end

  def show
  	@wiki = Wiki.find(params[:id])
  end

  def new
  	@wiki = Wiki.new
  end

  def create
  	@wiki = Wiki.new
    authorize @wiki

  	@wiki.title = params[:wiki][:title]
  	@wiki.body = params[:wiki][:body]
    if current_user.premium? || current_user.admin?
      @wiki.private = params[:wiki][:private]
  	else
      @wiki.private = false  
    end
    
    @wiki.user = current_user  

    if @wiki.save
      redirect_to @wiki, notice: "Wiki was saved successfully."
    else
      flash.now[:alert] = "Error creating wiki. Please try again."
      render :new
    end
  end

  def destroy
    @wiki = Wiki.find(params[:id])
    authorize @wiki
 
    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error deleting the wiki."
      render :show
    end
  end	

  def edit
  	@wiki = Wiki.find(params[:id])
    users = User.where.not(id: current_user.id)
    @wiki.users.each do |user|
      users = users.where.not(id: user.id)
    end
    @users = users.where.not(role: 2)
    @collaboration = Collaboration.new
  end

  def update
    @wiki = Wiki.find(params[:id])
    authorize @wiki

    @wiki.title = params[:wiki][:title]
  	@wiki.body = params[:wiki][:body]
    if (@wiki.user.id == current_user.id && current_user.premium?) || current_user.admin?
      @wiki.private = params[:wiki][:private]
    else
      @wiki.private = false  
    end
 
    if @wiki.save
      flash[:notice] = "Wiki was updated."
      redirect_to @wiki
    else
      flash.now[:alert] = "Error saving wiki. Please try again."
      render :edit
    end
  end	
end

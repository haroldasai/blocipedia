class CollaborationsController < ApplicationController

  def destroy
  	@wiki = Wiki.find(params[:wiki_id])
  	@collaboration = @wiki.collaborations.where(user_id: params[:collaboration][:user_id])

  	if collaboration.destroy
      flash[:notice] = "Collaborator removed."
    else
      flash[:alert] = "Removal failed."
    end
    
    redirect_to edit_wiki_path(@wiki)
  end

  def destroy_multiple
  	@wiki = Wiki.find(params[:id])
  	if Collaboration.destroy(params[:collaborations])
      flash[:notice] = "Collaborator removed."
    else
      flash[:alert] = "Removal failed."
    end
    
    redirect_to edit_wiki_path(@wiki)
  end

  def create
  	@wiki = Wiki.find(params[:wiki_id])
  	@collaboration = @wiki.collaborations.build(collaboration_params)
    #@collaboration = Collaboration.new
    #@collaboration.wiki_id = params[:wiki_id]
    #@collaboration.user_id = params[:user_id]

    if @collaboration.save
      flash[:notice] = "New collaborator was added."
      redirect_to edit_wiki_path(@wiki)
    else  
  # #12
      flash.now[:alert] = "There was an error adding collaborator. Please try again."
      redirect_to [@wiki]
    end
  end

  def create_multiple
  	@wiki = Wiki.find(params[:id])
  	collaborators = params[:collaborators]
    collaborators.each do |collaborator|
      @collaboration = @wiki.collaborations.build(:user_id => collaborator)
      if @collaboration.save
      	flash[:notice] = "New collaborator was added."
      else
        flash.now[:alert] = "There was an error adding collaborator. Please try again."
        break
      end
    end
    redirect_to edit_wiki_path(@wiki)
  end

  private
 
  def collaboration_params
    params.require(:collaboration).permit(:user_id)
  end

end

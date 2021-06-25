class PrototypesController < ApplicationController
  before_action :authenticate_user!, only:[:new, :edit, :destroy]
  before_action :move_to_root, except:[:index, :show, :create, :destroy]

  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path(@prototype)
    else
      render :new
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
     redirect_to prototype_path
    else
      render :edit
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to prototypes_path
  end

  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :consept, :image).merge(user_id: current_user.id)
  end

  def move_to_root
    @prototype = Prototype.find(params[:id])
    unless user_signed_in? && current_user.id == @prototype.user_id
      redirect_to root_path
    end
  end
end

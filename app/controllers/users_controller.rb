class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index ,:edit, :update]
  before_filter :corriger_utilisateur, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy
  def new
    @titre = "Inscription"
    @user = User.new
  end
  def index
    @titre = "Liste des utilisateurs"
    @users = User.paginate(:page => params[:page])
  end
  def show
    @user = User.find(params[:id])
    @titre = @user.nom
  end
  def create
    @user = User.new(params[:user])
      if @user.save
	sign_in @user
	flash[:success] = "Bienvenue dans l'application exemple !" 
	redirect_to @user
      else
      @titre = "Iscription"
      render 'new'
      end
  end
  def edit
    @user = User.find(params[:id])
    @titre = "Modification profil"
  end
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profil actualiser"
      redirect_to @user
    else
      @titre = "Modification profil"
      render 'edit'
    end
  end
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Utilisateur supprimer."
    redirect_to users_path
  end
  private
  
  def admin_user
    if signed_in?
    redirect_to(root_path) unless current_user.admin?
    else
      redirect_to signin_path
    end
  end
  
  def authenticate
    refuser_access unless signed_in?
  end
  
  def corriger_utilisateur
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
end
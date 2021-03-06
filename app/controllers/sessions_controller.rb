class SessionsController < ApplicationController
  
  def new
    @titre = "S'identifier"
  end
  
  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      flash.now[:error]="Email/Mot de passe invalide"
    @titre = "S'identifier"
    render 'new'
    else
      # Authentifier l'utilisateur et le rediriger vers sa page
      sign_in user
      revenir_arriere_ou user
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end

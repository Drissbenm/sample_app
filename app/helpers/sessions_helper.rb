module SessionsHelper
  
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
    
  end
  
  def signed_in?
   !current_user.nil? 
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= user_from_remember_token
  end
  
  def sign_out
    cookies.delete :remember_token
    self.current_user = nil
  end
  
  def refuser_access
    charger_location
    redirect_to signin_path, :notice => "Merci de vous identifier."
  end
  
  def current_user?(user)
    user==current_user
  end
  
  def revenir_arriere_ou(default)
    redirect_to(session[:return_to] || default)
    effacer_retour_a
  end
  
  private
  
  def effacer_retour_a
    session[:return_to] = nil
  end
  
  def charger_location
    session[:return_to] = request.fullpath
  end
  
  def user_from_remember_token
    User.authenticate_with_salt(*remember_token)
  end
  
  def remember_token
    cookies.signed[:remember_token] || [nil, nil]
  end
  
end

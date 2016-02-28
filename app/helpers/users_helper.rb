module UsersHelper
  def gravatar_for(user, options = { :size => 50 })
    gravatar_image_tag(user.email.downcase, :alt => user.nom,
                                            :class => 'gravatar',
                                            :gravatar => options)
  end
  def age_utilisateur (user)
    if user.age.nil?
       link_to "Ajouter votre date de naissance", edit_user_path(current_user) 
    else
    Date.today.year - @user.age.year
    end
  end
end

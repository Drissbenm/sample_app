# encoding: utf-8
require 'spec_helper'

describe "FriendlyForwardings" do
    it "devrait rediriger vers la page voulue après identification" do
      user = Factory(:user)
      visit edit_user_path(user)
      fill_in "eMail", :with => user.email
      fill_in "Mot de passe", :with => user.password
      click_button
      response.should render_template('users/edit')
    end
end

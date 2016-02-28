# encoding: utf-8
require 'spec_helper'

describe "Users" do
  
  describe "une inscription" do
    describe "ratée" do
      
      it "ne devrait pas créer un nouvelle utilisateur" do
	lambda do
	  visit signup_path
	  fill_in "Nom", :with => ""
	  fill_in "eMail", :with => ""
	  fill_in "Password", :with => ""
	  fill_in "Confirmation", :with => ""
	  click_button
	  response.should render_template('users/new')
	  response.should have_selector("div#error_explanation")
	end.should_not change(User, :count)
      end
      
    end
    describe "réussie" do
      
      it "devrait créer un nouvel utilisateur" do
	lambda do
	  visit signup_path
	  fill_in "Nom", :with => "Example User"
	  select "2", :from => "user_age_3i"
	  select "Septembre", :from => "user_age_2i"
	  select "1955", :from => "user_age_1i"
	  fill_in "eMail", :with => "user@example.com"
	  fill_in "Password", :with => "foobar"
	  fill_in "Confirmation", :with => "foobar"
	  click_button
	  response.should have_selector("div.flash.success", :content => "Bienvenue")
	end.should change(User, :count).by(1)
      end
      
    end
  end
  
  describe "identification/déconnexion" do
    describe "echec" do
      it "ne devrait pas identifier l'utilisateur" do
	visit signin_path
	fill_in "eMail", :with => ""
	fill_in "Mot de passe", :with => ""
	click_button
	response.should have_selector("div.flash.error", :content => "invalid")
      end
    end
    describe "succès" do
      it "devrait identifier un utilisateur puis le déconnecter" do
	user = Factory(:user)
	visit signin_path
	fill_in "eMail", :with => user.email
	fill_in "Mot de passe", :with => user.password
	click_button
	controller.should be_signed_in
	click_link "Déconnexion"
	controller.should_not be_signed_in
      end
    end
  end
end

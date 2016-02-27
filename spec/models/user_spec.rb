# encoding: utf-8
# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  nom        :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe User do
  before(:each) do
  @attr = { 
    :nom => "Example User", 
    :email => "user@example.com",
    :password => "foobar",
    :password_confirmation => "foobar"
  }
  end
  
  it "should create a new instance with a valid attribute"do
  User.create!(@attr)
  end
  
  it "devrait exiger un nom" do
    bad_guy = User.new(@attr.merge(:nom => ""))
    bad_guy.should_not be_valid
  end
  
  it "exige une adresse mail" do
    no_email_user=User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  it "devrait rejeter les noms trop longs" do
    long_nom = "a" * 51
    long_nom_user = User.new(@attr.merge(:nom => long_nom))
    long_nom_user.should_not be_valid
  end
  
  it "devrait accepter une adresse email valide" do
    adresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    adresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "devrait rejeter une adresse email invalide" do
    adresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    adresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
   it "devrait rejeter un email double" do
    # Place un utilisateur avec un email donné dans la BD.
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  it "devrait rejeter une adresse email invalide jusqu'à la casse" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  describe "password validations" do
    it "devrait exiger un mot de passe" do
      User.new(@attr.merge(:password => "", :password_confirmation => ""))
      should_not be_valid
    end
    
    it "devrait rejeter les mots de passe (trop) courts" do
    short = "a" * 5
    hash = @attr.merge(:password => short, :password_confirmation => short)
    User.new(hash).should_not be_valid
    end
    
    it "devrait rejeter les mots de passe (trop) longs" do
    long = "a" * 41
    hash = @attr.merge(:password => long, :password_confirmation => long)
    User.new(hash).should_not be_valid
    end
  end
  
  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "devrait avoir un attribut mot de passe crypté" do
    @user.should respond_to(:encrypted_password)
    end
    
    it "devrait définir le mot de passe crypté" do
      @user.encrypted_password.should_not be_blank
    end
    
    describe "Méthode has_password" do
      it "doit retourner true si les mots de passes sont identiques" do
	@user.has_password?(@attr[:password]).should be_true
      end
      
      it "doit retourner false si les motes de passes ne sont pas identiques" do
	@user.has_password?("invalide").should be_false
      end
    end
    
    describe "authenticate method" do

      it "devrait retourner nul en cas d'inéquation entre email/mot de passe" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end

      it "devrait retourner nil quand un email ne correspond à aucun utilisateur" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end

      it "devrait retourner l'utilisateur si email/mot de passe correspondent" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end
  end
  describe "Attribut admin" do
    before(:each) do
      @user = User.create!(@attr)
    end
    it "devrait confirmer l'existance de l'admin" do
      @user.should respond_to(:admin)
    end
    it "ne devrait pas être un administrateur" do
      @user.should_not be_admin
    end
    it "devrait pouvoir devenir administrateur" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end
end

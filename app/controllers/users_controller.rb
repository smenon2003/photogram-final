class UsersController < ApplicationController
  skip_before_action(:authenticate_user!, { :only => [:index] })
  def index
    matching_users = User.all
    @list_of_users = matching_users.order({ :created_at => :desc })
    render({ :template => "users/index" })
  end 

end 

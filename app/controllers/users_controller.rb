class UsersController < ApplicationController
  skip_before_action(:authenticate_user!, { :only => [:index] })
  def index
    puts "Hi, I'm printing this from the INDEX ACTION "
    matching_users = User.all
    @list_of_users = matching_users.order({ :created_at => :desc })
    render({ :template => "users/index" })
  end 

  def afterForm
    uname = params["user"]["username"] 
    puts " the retreived username data is: #{uname}"
    current_user.username = uname
    current_user.save
    index 
  end


end 

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

    email = params["user"]["email"] 
    puts " the retreived email data is: #{email}"
    current_user.email = email
    current_user.save
    index 
  end

  def userProfile 
    @user_2_show_uname = params.fetch("user_name_p")
    @user_2_show = User.where(:username => @user_2_show_uname).at(0)
    @matching_photos = Photo.where( :owner_id => user_2_show.id)

    #. find the number of followers 
    @follower_count = Follow_request.where(:recipient => user_2_show.id, :status => "accepted").count
    
    # find the number of following 
    @following_count = Follow_request.where(:sender => user_2_show.id, :status => "accepted").count

    render({ :template => "users/profile" })
  end


end 

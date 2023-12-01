class UsersController < ApplicationController
  skip_before_action(:authenticate_user!, { :only => [:index] })
  UserWithStatus = Struct.new(:user, :hasBeenAccepted, :hasBeenPending, :hasBeenRejected )


  def index
    puts "Hi, I'm printing this from the INDEX ACTION "
    matching_users = User.all
    
  
    @list_of_users = matching_users.order({ :created_at => :desc })


    

    randUser = User.all.at(0)

    if user_signed_in?
      #puts "YES THE USER IS SINGED IN!!!!"
      #. dtermine which of these cases a given user falls in:
      #. no_req_sent (that's been accepted or pending), req_sent_no_reply, req_sent_accepted

      @list_status_users = @list_of_users.map do |user_iter |
        hasBeenAccepted = FollowRequest.where(:sender => current_user.id, :recipient => user_iter.id, :status => "accepted").exists?
        hasBeenPending = FollowRequest.where(:sender => current_user.id, :recipient => user_iter.id, :status => "pending").exists?
        hasBeenRejected = FollowRequest.where(:sender => current_user.id, :recipient => user_iter.id, :status => "rejected").exists?
        UserWithStatus.new(user_iter, hasBeenAccepted, hasBeenPending, hasBeenRejected)
      

      end 
    else 
      @list_status_users  = @list_of_users

    end 

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
    @matching_photos = Photo.where( :owner_id => @user_2_show.id)

    #. find the number of followers 
    @follower_count = FollowRequest.where(:recipient => @user_2_show.id, :status => "accepted").count
    
    # find the number of following 
    @following_count = FollowRequest.where(:sender => @user_2_show.id, :status => "accepted").count

    render({ :template => "users/profile" })
  end


end 

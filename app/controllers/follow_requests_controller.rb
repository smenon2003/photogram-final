class FollowRequestsController < ApplicationController
  def index
    matching_follow_requests = FollowRequest.all

    @list_of_follow_requests = matching_follow_requests.order({ :created_at => :desc })

    render({ :template => "follow_requests/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_follow_requests = FollowRequest.where({ :id => the_id })

    @the_follow_request = matching_follow_requests.at(0)

    render({ :template => "follow_requests/show" })
  end

  def create
    the_follow_request = FollowRequest.new
    the_follow_request.recipient_id = params.fetch("query_recipient_id")
    recip_user = User.find( params.fetch("query_recipient_id")  )
    the_follow_request.sender_id = current_user.id #params.fetch("query_sender_id")
    if recip_user.private 
      the_follow_request.status = "pending"
    else 
      the_follow_request.status = "accepted"
    end

    if the_follow_request.valid?
      the_follow_request.save
      flash[:notice] = "Follow request updated successfully."
      #redirect_to("/follow_requests", { :notice => "Follow request created successfully." })
    else
      #redirect_to("/follow_requests", { :alert => the_follow_request.errors.full_messages.to_sentence })
    end

    if params.include?(:stay_on_profile)
      redirect_to controller: :users, action: :userProfile, user_name_p: recip_user.username 
    else 
      redirect_to controller: :users, action: :index 
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_follow_request = FollowRequest.where({ :id => the_id }).at(0)

    the_follow_request.recipient_id = params.fetch("query_recipient_id")
    the_follow_request.sender_id = params.fetch("query_sender_id")
    the_follow_request.status = params.fetch("query_status")

    if the_follow_request.valid?
      the_follow_request.save
      flash[:notice] = "Follow request updated successfully."
      #redirect_to("/follow_requests/#{the_follow_request.id}", { :notice => "Follow request updated successfully."} )
    else
      #flash[:notice] = "Follow request updated successfully."
      #redirect_to("/follow_requests/#{the_follow_request.id}", { :alert => the_follow_request.errors.full_messages.to_sentence })
    end
    redirect_to controller: :users, action: :index 
  end

  def destroy
    recipient_id = params.fetch("path_id")
    the_follow_request = FollowRequest.where({ :sender => current_user.id, :recipient => recipient_id }).at(0)

    the_follow_request.destroy

    flash[:notice] = "Follow request deleted successfully."
    #render({ :template => "users/index" })
    #redirect_to("users/index", { :notice => "Follow request deleted successfully."}, allow_other_host: true )
    redirect_to controller: :users, action: :index 
  end

  def destroyAndStay
    recipient_id = params.fetch("path_id")
    recip_user = User.find(recipient_id)
    the_follow_request = FollowRequest.where({ :sender => current_user.id, :recipient => recipient_id }).at(0)

    the_follow_request.destroy

    flash[:notice] = "Follow request deleted successfully."
    #render({ :template => "users/index" })
    #redirect_to("users/index", { :notice => "Follow request deleted successfully."}, allow_other_host: true )
    redirect_to controller: :users, action: :userProfile, user_name_p: recip_user.username 
  end
end

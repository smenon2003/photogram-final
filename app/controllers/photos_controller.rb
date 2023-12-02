class PhotosController < ApplicationController
  skip_before_action(:authenticate_user!, { :only => [:index] })
  CommentStruct = Struct.new(:authorName, :commentTxt, :dateInWords )

  def index
    matching_photos = Photo.all

    @list_of_photos = matching_photos.order({ :created_at => :desc })

    render({ :template => "photos/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_photos = Photo.where({ :id => the_id })

    @the_photo = matching_photos.at(0)

    matching_comments = Comment.where({:photo => the_id})
    @list_comment_structs = matching_comments.map do |comment_iter |
      commenter = User.find(comment_iter.author_id)
      CommentStruct.new(commenter.username, comment_iter.body, comment_iter.created_at  )
    end 


    render({ :template => "photos/show" })
  end

  def create
    the_photo = Photo.new
    the_photo.caption = params.fetch("query_caption")
    the_photo.comments_count = 0
    #if params.include?(:uploadsource)
    the_photo.image = params.fetch("query_image")
    #else 
    #  the_photo.image = params.fetch("query_image")
    #end
    the_photo.likes_count = 0
    the_photo.owner_id = current_user.id 

    if the_photo.valid?
      the_photo.save
      redirect_to("/photos", { :notice => "Photo created successfully." })
    else
      redirect_to("/photos", { :alert => the_photo.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_photo = Photo.where({ :id => the_id }).at(0)

    the_photo.caption = params.fetch("query_caption")
    the_photo.comments_count = params.fetch("query_comments_count")
    if params.include?(:uploadsource)
      the_photo.image = params.fetch(:uploadsource)
    else 
      the_photo.image = params.fetch("query_image")
    end
    the_photo.likes_count = params.fetch("query_likes_count")
    the_photo.owner_id = params.fetch("query_owner_id")

    if the_photo.valid?
      the_photo.save
      redirect_to("/photos/#{the_photo.id}", { :notice => "Photo updated successfully."} )
    else
      redirect_to("/photos/#{the_photo.id}", { :alert => the_photo.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_photo = Photo.where({ :id => the_id }).at(0)

    the_photo.destroy

    redirect_to("/photos", { :notice => "Photo deleted successfully."} )
  end
end

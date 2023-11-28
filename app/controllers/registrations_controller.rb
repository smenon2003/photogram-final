class RegistrationsController < Devise::RegistrationsController
   
  def edit
    puts "Hi, I'm printing this from the edit!!!! "
    puts " the current user's username is: #{current_user.id}"
    

    if user_signed_in? 
      puts "User is supposedly signed in..."
    else 
      puts "User isn't signed in... but they are tho... but for some reason user_singined_in is false "
    end 
    render({ :template => "users/edit" })
  end 

end 

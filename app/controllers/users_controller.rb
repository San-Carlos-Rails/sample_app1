class UsersController < ApplicationController
 #Requiring logged-in users
 # To require users to be logged in, we define 
 #a logged_in_user method and invoke it using before_action :logged_in_user
 before_action :logged_in_user, only: [:edit, :update]


  def index
   
  end



  def new
   #@user = User.find
   @user = User.new
  end

   def show
    @user = User.find(params[:id])
  end


  def create
    #previous code"
    #@user = User.new(params[:user])    # Not the final implementation!
    
    #then use user_params here then add a private method below
    @user = User.new(user_params)    # Not the final implementation!
    if @user.save
      # Handle a successful save.
      log_in @user
      flash[:success] = "Welcome to the Blog App!"
      redirect_to @user
    else
      render 'new'
    end
  end


  def edit
    @user = User.find(params[:id])
  end


  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update.
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end



#----------------------------------------------------------------------
    #Note: Since user_params will only be used internally by the 
    #Users controller and need not be exposed to external users via the 
    #web, we’ll make it private using Ruby’s private keyword
#----------------------------------------------------------------------
#Add private method
private

#Note:In the present instance, we want to require the 
#params hash to have a :user attribute, and we 
#want to permit the name, email, password, and 
#password confirmation attributes (but no others).
#We can accomplish this as follows:


  def user_params
    
    #Note:This code returns a version of the params 
    #hash with only the permitted attributes (while raising 
    #an error if the :user attribute is missing).
   params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
  end

    #Note: To facilitate the use of these parameters, it’s conventional 
    #to introduce an auxiliary method 
    #called user_params (which returns an appropriate initialization hash) 
    #and use it in place of params[:user]:
    #@user = User.new(user_params)


#--------------------------
 # Before filters
 #--------------------------
 #By default, before filters apply to every action in a controller, so here we restrict the 
 #filter to act only on the :edit and :update actions by passing the appropriate :only options hash.
 #We can see the result of the before filter in Listing 9.12 by logging out and attempting to 
 #access the user edit page /users/1/edit, as seen in Figure 9.7.
#--------------------------
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end

class Users::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]
   prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  # prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy, :show]


  def create_user
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path , :notice => "User created successfully"
    else
      puts @user.errors.full_messages
      render "users/new"
    end
  end

  def update_user
    @user = User.find_by_id(user_params[:id])
    if @user.update(user_params)
      redirect_to users_path , :notice => "User updated successfully"
    else
      puts @user.errors.full_messages
      render "/users/registrations/edit"
    end
  end

# GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    #super(resource)
    root_path
  end

   private
   def user_params
     params.require(:user).permit(:name, :email, :password , :password_confirmation , :role , :created_by_id , :id)
   end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end

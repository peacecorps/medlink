class PasswordsController < Devise::PasswordsController
	def create
		user = User.find_by_email(params[:user][:email])
		if !user || (user.pcv_id != params[:user][:pcv_id])
			flash[:notice] = "Please make sure you entered the correct email and PCVID."
			redirect_to new_user_password_path and return
		end

		self.resource = resource_class.send_reset_password_instructions(resource_params)
	    if successfully_sent?(resource)
	      	respond_with({}, :location => after_sending_reset_password_instructions_path_for(resource_name))
	    else
	    	respond_with(resource)
	    end
	end
end

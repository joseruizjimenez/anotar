class RegistrationsController < Devise::RegistrationsController

  def new
    super
  end

  def create
    super
  end

  def edit
    super
  end

  def update
    super
  end

  def destroy
    super
  end

  def cancel
    super
  end

  protected

  def build_resource(hash=nil)
    hash ||= resource_params || {}
    self.resource = resource_class.new_with_session(hash, session)
    unless params[:user].nil? || params[:user][:opt_in].nil? || params[:user][:opt_in] == 0
      if session.has_key?(:session_credential_id)
        old_user = SessionCredential.find_by_session_id session[:session_credential_id]
        if old_user.nil?
          self.resource.author_id = SessionCredential.generate_id
        else
          self.resource.author_id = old_user.author_id
        end
      else
        self.resource.author_id = SessionCredential.generate_id
      end
    end
  end

end
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
    if session.has_key?(:session_credential_id)
      @user_session_credential = SessionCredential.find_by_session_id session[:session_credential_id]
      self.resource.author_id = @user_session_credential.author_id
      @user_session_credential.destroy
    else
      self.resource.author_id = SessionCredential.generate_id
    end
  end

end
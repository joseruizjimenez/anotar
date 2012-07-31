class NotesController < ApplicationController

  def index
    if user_signed_in?
      if session.has_key? :session_credential_id
        old_user = SessionCredential.find_by_session_id session[:session_credential_id]
        unless old_user.nil?
          session[:session_credential_id] = nil
          old_user.destroy
        end
      end
      @notes = current_user.notes.sort_by(&:updated_at).reverse
    elsif session.has_key? :session_credential_id
      user_credential = SessionCredential.find_by_session_id session[:session_credential_id]
      unless user_credential.nil?
        user_credential.increment! :visits
        @notes = Note.find_all_by_author_id(user_credential.author_id, :order => :updated_at).reverse
      end
    else
      @welcome = true
    end
  end

  def create
    if user_signed_in?
      new_note = current_user.notes.create(params[:note])
      if !new_note.new_record?
        @notes = current_user.notes.sort_by(&:updated_at).reverse
        # flash[:notice] = "Your note was added succesfully!"
      else
        flash.now[:alert] = "Oops! Something went wrong... please try again"
        @notes = current_user.notes.sort_by(&:updated_at).reverse
        @old_text = new_note.text
      end
    else
      if session.has_key?(:session_credential_id)
        user_credential = SessionCredential.find_by_session_id(session[:session_credential_id])
      end
      if user_credential.nil?
        user_credential = SessionCredential.create
        session[:session_credential_id] = user_credential.session_id
      end
      if !user_credential.new_record?
        new_note = Note.create(:author_id => user_credential.author_id, :text => params[:note][:text])
        @notes = Note.find_all_by_author_id(user_credential.author_id, :order => :updated_at).reverse
        if !new_note.new_record?
          flash.now[:notice] = "Success! Please <b>sing up</b> to keep your notes safe"
        else
          flash.now[:alert] = "Oops! Something went wrong... please try again"
          @notes = Note.find_all_by_author_id(user_credential.author_id, :order => :updated_at).reverse
          @old_text = new_note.text
        end
      else
        flash.now[:alert] = "Oops! Something went wrong... please try again"
        @old_text = new_note.text
      end
    end
    render :index
  end

  def edit
    if user_signed_in?
      @note = current_user.notes.find params[:id]
    elsif session.has_key? :session_credential_id
      user_credential = SessionCredential.find_by_session_id session[:session_credential_id]
      unless user_credential.nil?
        @note = Note.where(:author_id => user_credential.author_id, :id => params[:id]).first
      end
    end
    if @note.nil?
      flash[:alert] = "Oops! Note not found!"
      redirect_to notes_path
    end
  end

  def update
    if user_signed_in?
      @note = current_user.notes.find params[:id]
    elsif session.has_key? :session_credential_id
      user_credential = SessionCredential.find_by_session_id session[:session_credential_id]
      unless user_credential.nil?
        @note = Note.where(:author_id => user_credential.author_id, :id => params[:id]).first
      end
    end
    if @note.nil?
      redirect_to notes_path
    else
      if @note.update_attributes params[:note]
        flash.now[:notice] = "Your note was <b>edited</b> succesfully!"
        render :show
      else
        flash.now[:alert] = "Oops! Something went wrong... please try again"
        render :edit
      end
    end
  end

  def show
    if user_signed_in?
      @note = current_user.notes.find params[:id]
    elsif session.has_key? :session_credential_id
      user_credential = SessionCredential.find_by_session_id session[:session_credential_id]
      unless user_credential.nil?
        @note = Note.where(:author_id => user_credential.author_id, :id => params[:id]).first
      end
    end
    if @note.nil?
      @note = Note.find_by_id params[:id]
      if !@note.nil? && @note.shared
        @shared = true
      else
        redirect_to notes_path
      end
    end
  end

  def destroy
    if user_signed_in?
      note = current_user.notes.find params[:id]
      if !note.nil?
        current_user.notes.delete note
        flash.now[:notice] = "Your note was <b>deleted</b> succesfully!"
        @notes = current_user.notes.sort_by(&:updated_at).reverse
        render :index
      else
        redirect_to notes_path
      end
    elsif session.has_key? :session_credential_id
      user_credential = SessionCredential.find_by_session_id session[:session_credential_id]
      if !user_credential.nil?
        note = Note.where(:author_id => user_credential.author_id, :id => params[:id]).first
        if !note.nil?
          note.destroy
          flash.now[:notice] = "Your note was <b>deleted</b> succesfully!"
          @notes = Note.find_all_by_author_id(user_credential.author_id, :order => :updated_at).reverse
          render :index
        else
          redirect_to notes_path
        end
      else
        redirect_to notes_path
      end
    else
      redirect_to notes_path
    end
  end

  def all
    if user_signed_in?
      @notes = current_user.notes.sort_by(&:updated_at).reverse
    elsif session.has_key? :session_credential_id
      user_credential = SessionCredential.find_by_session_id session[:session_credential_id]
      unless user_credential.nil?
        @notes = Note.find_all_by_author_id(user_credential.author_id, :order => :updated_at).reverse
      end
    end
  end

  def favs
    if user_signed_in?
      @notes = Note.where(:author_id => current_user.author_id, :fav => true).sort_by(&:updated_at).reverse
    elsif session.has_key? :session_credential_id
      user_credential = SessionCredential.find_by_session_id session[:session_credential_id]
      unless user_credential.nil?
        @notes = Note.where(:author_id => user_credential.author_id, :fav => true).sort_by(&:updated_at).reverse
      end
    end
    @fav = true
    render :all
  end

  def shared
    if user_signed_in?
      @notes = Note.where(:author_id => current_user.author_id, :shared => true).sort_by(&:updated_at).reverse
    elsif session.has_key? :session_credential_id
      user_credential = SessionCredential.find_by_session_id session[:session_credential_id]
      unless user_credential.nil?
        @notes = Note.where(:author_id => user_credential.author_id, :shared => true).sort_by(&:updated_at).reverse
      end
    end
    @shared = true
    render :all
  end

end
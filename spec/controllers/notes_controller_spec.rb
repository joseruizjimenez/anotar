require 'spec_helper'

describe NotesController do

  describe 'GET index' do
    it 'should check if the user is logged in' do
      DeviseHelper.should_receive(:user_signed_in?)
      get :index
      #LoginCredential.should_receive(:find_by_access_token).with('an_access_token')
      #get :index, :access_token => 'an_access_token'
    end

    it 'should use the session id to get the session_credential (logged out)' do
      SessionCredential.should_receive(:find_by_session_id).with('a_session_id')
      get :index, :session_credential_id => 'a_session_id'
    end

    it 'should find all the user_id notes (logged in)' do
      @fake_login_credential = FactoryGirl.create(:login_credential, :user_id => 'an_user_id')
      LoginCredential.stub(:find_by_access_token).and_return(@fake_login_credential)
      Note.should_receive(:find_by_user_id).with(@fake_login_credential.user_id)
      get :index, :access_token => 'an_access_token'
    end

    it 'should find all the session_user_id notes (logged out)' do
      @fake_session_credential = FactoryGirl.create(:session_credential, :user_id => 'an_user_id')
      SessionCredential.stub(:find_by_session_id).and_return(@fake_session_credential)
      Note.should_receive(:find_by_user_id).with(@fake_session_credential.user_id)
      get :index, :session_credential_id => 'a_session_id'
    end

    it 'should apology for erasing the notes (if session_user_id is not found)' do
      SessionCredential.stub(:find_by_session_id).and_return(nil)
      get :index, :session_credential_id => 'a_not_found_session_id'
      flash[:alert].should match("We are sorry, we lost the track of "+
        "your session. <br /> Please Sign up to prevent this")
    end

    it 'should select the Index Notes template for rendering (logged in)' do
      @fake_login_credential = FactoryGirl.create(:login_credential, :user_id => 'an_user_id')
      @fake_notes = [mock('note1'), mock('note2')]
      LoginCredential.stub(:find_by_access_token).and_return(@fake_login_credential)
      Note.stub(:find_by_user_id).and_return(@fake_notes)
      get :index, :access_token => 'an_access_token'
      response.should render_template notes_path
    end

    it 'should select the Index Notes template for rendering (logged out)' do
      @fake_session_credential = FactoryGirl.create(:session_credential, :user_id => 'an_user_id')
      @fake_notes = [mock('note1'), mock('note2')]
      SessionCredential.stub(:find_by_session_id).and_return(@fake_session_credential)
      Note.stub(:find_by_user_id).and_return(@fake_notes)
      get :index, :session_credential_id => 'a_session_id'
      response.should render_template notes_path
    end

    it 'should make the user notes avaliable to the template (logged in)' do
      @fake_login_credential = FactoryGirl.create(:login_credential, :user_id => 'an_user_id')
      @fake_notes = [mock('note1'), mock('note2')]
      LoginCredential.stub(:find_by_access_token).and_return(@fake_login_credential)
      Note.stub(:find_by_user_id).and_return(@fake_notes)
      get :index, :access_token => 'an_access_token'
      assigns[:notes].should == @fake_notes
    end

    it 'should make the user notes avaliable to the template (logged out)' do
      @fake_session_credential = FactoryGirl.create(:session_credential, :user_id => 'an_user_id')
      @fake_notes = [mock('note1'), mock('note2')]
      SessionCredential.stub(:find_by_session_id).and_return(@fake_session_credential)
      Note.stub(:find_by_user_id).and_return(@fake_notes)
      get :index, :session_credential_id => 'a_session_id'
      assigns[:notes].should == @fake_notes
    end

    it 'should not show any notes if the (not logged) user never create one' do
      # neither access_token nor session_id are found
      get :index
      assigns[:notes].should == nil
    end
  end

end
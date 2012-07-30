require 'uuidtools'
require 'base64'

class SessionCredential < ActiveRecord::Base
  after_find :find_aux
  after_initialize :init

  attr_accessor :author_id, :session_id, :updated_at, :created_at, :visits

  # Adds a random author_id
  def init
    if @read_session
      @session_id = self[:session_id]
      @author_id = self[:author_id]
      @visits = self[:visits]
      @updated_at = self[:updated_at]
      @created_at = self[:created_at]
      @id = self[:id]
    else
      self[:session_id] = SessionCredential.generate_id
      self[:author_id] = SessionCredential.generate_id
      @session_id = self[:session_id]
      @author_id = self[:author_id]
      @visits = self[:visits]
      @updated_at = self[:updated_at]
      @created_at = self[:created_at]
      @id = self[:id]
    end
  end

  def find_aux
    @read_session = true
  end

  def self.generate_id
    Base64.encode64(UUIDTools::UUID.random_create)[0..8]
  end

  def hashtags
    Note.find_all_by_author_id(self.author_id).map { |n| n.hashtags.each { |h| h } }.uniq
  end

end
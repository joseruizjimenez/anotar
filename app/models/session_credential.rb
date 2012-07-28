require 'uuidtools'
require 'base64'

class SessionCredential < ActiveRecord::Base

  attr_accessor :author_id, :session_id, :updated_at, :created_at, :visits

  def self.generate_id
    Base64.encode64(UUIDTools::UUID.random_create)[0..8]
  end

  # Adds a random author_id
  before_create do
    self.session_id = generate_id
    self.author_id = generate_id
  end

  def hashtags
    Note.find_all_by_author_id(self.author_id).map { |n| n.hashtags.each { |h| h } }.uniq
  end

end
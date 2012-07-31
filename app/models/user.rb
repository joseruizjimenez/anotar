# require 'uuidtools'
# require 'base64'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  has_many :notes, :foreign_key => :author_id, :primary_key => :author_id

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation,
    :remember_me, :confirmed_at, :opt_in, :login
  # attr_accessible :title, :body

  attr_accessor :login, :updated_at, :created_at

  validates_presence_of :username, :email, :password, :password_confirmation, :opt_in
  validates_uniqueness_of :username, :case_sensitive => false

  # Adds a random author_id
  # before_create do
  #   self.author_id = Base64.encode64(UUIDTools::UUID.random_create)[0..8]
  # end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def hashtags
    hashtags_list = []
    self.notes.each { |n| n.hashtags.each { |h| hashtags_list.push(h) } }
    hashtags_list.uniq
  end

  def hashtag_notes(name)
    hashtag_notes = []
    self.notes.each do |n|
      n.hashtags.each { |h| if h.name == name then hashtag_notes.push(n) end }
    end
    hashtag_notes.uniq
  end

end

class Hashtag < ActiveRecord::Base

  attr_accessor :name, :hits, :updated_at, :created_at
  attr_accessible :name, :hits

  validates_presence_of :name
  validates_uniqueness_of :name

  after_find :init

  def init
    @name = self[:name].downcase
    @hits = self[:hits]
    @updated_at = self[:updated_at]
    @created_at = self[:created_at]
    @id = self[:id]
  end

  before_save do
    self[:name] = @name.downcase
    if self.new_record?
      self[:hits] = 0
    else
      self[:hits] = @hits
    end
    @updated_at = self[:updated_at]
    @created_at = self[:created_at]
    @id = self[:id]
  end

  before_validation do
    self[:name] = @name.downcase
  end

end
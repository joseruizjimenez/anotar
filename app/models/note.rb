class Note < ActiveRecord::Base

  has_and_belongs_to_many :hashtags

  attr_accessor :author_id, :title, :text, :html_text, :edit_count, :shared,
    :fav, :updated_at, :created_at, :id
  attr_accessible :text

  validates_presence_of :author_id

  before_save do
    self.text.strip!
    self.set_title_from_text!
    self.set_hashtags_from_text!
    self.edit_count += 1 unless self.new_record?
    self.set_shared_state!
    self.set_fav_state!
    self.set_html_text!
  end

  def set_title_from_text!
    new_title = /@[tT][iI][tT][lL][eE]\{(.+)\}/.match(self.text)
    new_title.nil? ? new_title = '' : new_title = truncate(new_title[1].strip,
      :length => 60, :separator => ' ')
    # also adds links to hashtag search
    self.title= truncate(text_with_linked_hashtags(new_title),
      :length => 254, :separator => ' <a')
  end

  def set_hashtags_from_text!
    new_hashtag_names = []
    new_hashtags = []
    self.text.scan(/#(\w+)/) { |tag| new_hashtag_names.push(tag) }
    existing_hashtags = Hashtag.all(:conditions => {:name => new_hashtag_names})
    existing_hashtags.each do |tag|
      tag.with_lock do
        tag.increment! :hits
      end
      new_hashtag_names.pop tag.name
      new_hashtags.push tag
    end
    #now we create the new ones
    new_hashtag_names.each do |new_name|
      new_hashtags.push Hashtag.create(:name => new_name)
    end
    self.hashtags= new_hashtags
  end

  def set_html_text!
    new_html_text = self.text
    # Remove note tags
    new_html_text.gsub!(/@[tT][iI][tT][lL][eE]\{.+\}/,'')
    new_html_text.gsub!(/@public@/i,'')
    new_html_text.gsub(/@fav@/i,'').strip!
    # Adds bold tags
    new_html_text.gsub!(/\*[[:print:]&&[^\*]]*\*/) do |b|
      bold_text = b[1...-1]
      bold_text == '' ? '**' : "<b>"+bold_text+"</b>"
    end
    # Adds italic tags
    new_html_text.gsub!(/_[[:print:]&&[^_]]+_/) do |b|
      "<i>"+b[1...-1]+"</i>"
    end
    self.text= text_with_linked_hashtags new_html_text
  end

  def set_shared_state!
    shared_state = /@public@/i.match(self.text)
    self.shared= !!shared_state
  end

  def set_fav_state!
    fav_state = /@fav@/i.match(self.text)
    self.fav= !!fav_state
  end

  def text_with_linked_hashtags(text_to_link)
    text_to_link.gsub(/#\w+/) do |h|
      "<a class='hashtag' href='/hashtags/"+h[1..-1]+"'>"+h+"</a>"
    end
  end


end
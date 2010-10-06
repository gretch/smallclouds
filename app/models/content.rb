class Content < ActiveRecord::Base

  validates_uniqueness_of :title, :scope => [:type]
  validates_uniqueness_of :shortname, :scope => [:type]

  acts_as_commentable

  belongs_to :category

  belongs_to :user

  before_save :assign_shortname

  named_scope :published, :conditions => { :published => true }
  named_scope :recent, :order => "created_at DESC", :limit => 3, :include => [:comments]
  named_scope :most_commented, :conditions => "comments_count > 0", :order => "hits DESC, created_at DESC", :limit => 4, :include => [:comments]

  named_scope :most_read, :conditions => "hits > 0", :order => "hits DESC, created_at DESC", :limit => 4, :include => [:comments]

  def self.find_by_param(param)
    find(:first, :conditions => {:shortname => param}, :include => [:comments])
  end

  def to_param
    shortname
  end

  def published!
    self.update_attribute(:published, true)
  end

  def unpublished!
    self.update_attribute(:published, false)
  end

  protected

    def assign_shortname
      self.shortname = if self.title.blank?
        ''
      else
        self.shortname = to_safe_url(self.title)
      end
    end

  def to_safe_url(str)
    # taken from friendly ID
    return "" if str.blank?
    ActiveSupport::Multibyte.proxy_class.new(str).normalize(:kc).
      # For some reason Spanish ¡ and ¿ are not detected as non-word
      # characters. Bug in Ruby?
      gsub(/[\W|¡|¿]/u, ' ').
      strip.
      gsub(/\s+/u, '-').
      gsub(/-\z/u, '').
      downcase.
      to_s
  end
end

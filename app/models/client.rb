class Client < ActiveRecord::Base

  has_many :projects

  validates :name, presence: true

  def self.lazy_find_by_name(name)
    self.find_by_name(name) || self.new(name: name)
  end
end

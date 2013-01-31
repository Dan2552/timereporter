class Project < ActiveRecord::Base

  has_many :time_entries
  belongs_to :client

  validates :name, presence: true

  scope :ordered_by_name, order: 'name ASC'

  def self.fetch_remote_projects(args = {})
    PodioProjectFetcher.new(args).fetch
  end

  def self.lazy_find_by_name(name)
    self.find_by_name(name) || self.new(name: name)
  end

end

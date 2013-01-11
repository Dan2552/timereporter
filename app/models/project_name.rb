class ProjectName < ActiveRecord::Base

  belongs_to :client_name

  def client
    client_name.try(:value)
  end

end

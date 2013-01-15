class RemoveApiTokenFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :api_token
  end
end

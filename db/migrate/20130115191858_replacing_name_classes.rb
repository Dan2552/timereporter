class ReplacingNameClasses < ActiveRecord::Migration
  def change
    rename_table :client_names, :clients
    drop_table :project_names
    add_column :projects, :client_id, :integer
    add_column :clients, :name, :string
    remove_column :clients, :value
  end
end

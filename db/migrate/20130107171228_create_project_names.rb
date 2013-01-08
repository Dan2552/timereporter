class CreateProjectNames < ActiveRecord::Migration
  def change
    create_table :project_names do |t|
      t.string :value
      t.integer :client_name_id

      t.timestamps
    end
  end
end

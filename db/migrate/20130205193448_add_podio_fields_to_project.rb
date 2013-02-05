class AddPodioFieldsToProject < ActiveRecord::Migration
  def change
    drop_table :projects
    drop_table :clients

    create_table :projects do |t|
      t.string :title
      t.string :client_company
      t.string :contact
      t.string :project_type
      t.string :status
      t.string :utilised
      t.string :billable
      t.string :related_role
      t.timestamps
    end

  end
end

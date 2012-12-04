class CreateTimeEntries < ActiveRecord::Migration
  def change
    create_table :time_entries do |t|
      t.datetime :entry_datetime
      t.integer :duration
      t.integer :project_id
      t.string :comment
      t.integer :user_id

      t.timestamps
    end
  end
end

class CreateUserPreferences < ActiveRecord::Migration
  def change
    create_table :user_preferences do |t|
      t.integer :contracted_day_minutes
      t.time :day_start_preference, default: Time.parse("8:00am")
      t.time :day_end_preference, default: Time.parse("8:00pm")
      t.integer :user_id
      t.timestamps
    end
  end
end

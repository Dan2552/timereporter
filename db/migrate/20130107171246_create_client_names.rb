class CreateClientNames < ActiveRecord::Migration
  def change
    create_table :client_names do |t|
      t.string :value

      t.timestamps
    end
  end
end

class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :name
      t.string :description
      t.datetime :event_at
      t.integer :duration

      t.timestamps
    end
  end
end

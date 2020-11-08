class CreateJoinTableUserEvent < ActiveRecord::Migration[5.0]
  def change
  	create_table :invites do |t|
  		t.references :user, foreign_key: true
  		t.references :event, foreign_key: true
  		t.boolean :is_owner, default: false
  		t.string :status
  		t.index [:user_id, :event_id], unique: true
  	end
  end
end

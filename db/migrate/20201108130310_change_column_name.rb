class ChangeColumnName < ActiveRecord::Migration[5.0]
  def change
  	rename_column :invites, :is_owner, :owner
  end
end

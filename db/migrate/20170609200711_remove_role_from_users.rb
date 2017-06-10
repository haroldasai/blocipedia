class RemoveRoleFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :admin
    remove_column :users, :premium
  end  
end

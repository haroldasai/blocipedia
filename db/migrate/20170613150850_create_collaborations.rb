class CreateCollaborations < ActiveRecord::Migration
  def change
    create_table :collaborations do |t|
      t.integer :wiki_id
      t.integer :user_id

      t.timestamps null: false
    end

    add_index :wikis, :id, unique: true
    add_index :users, :id, unique: true
    add_index :collaborations, :id, unique: true
    add_index :collaborations, :wiki_id
    add_index :collaborations, :user_id
  end  
end

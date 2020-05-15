class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.integer :role, default: 0
      t.string :name
      t.string :email, unique: true
      t.string :phone
      t.string :picture
    end
  end
end

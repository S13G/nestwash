class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email_address, null: false, index: { unique: true }
      t.string :password_digest
      t.string :full_name
      t.string :address
      t.string :role
      t.timestamps
    end

    add_index :users, :role
  end
end

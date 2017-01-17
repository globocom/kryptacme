class CreateOwners < ActiveRecord::Migration[5.0]
  def change
    create_table :owners do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.text :private_pem, limit: 64.kilobytes-1
      t.text :detail
      t.string :acme_id

      t.timestamps
    end
    add_index :owners, :name, unique: true
    add_index :owners, :email, unique: true
  end
end

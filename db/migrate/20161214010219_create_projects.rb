class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.text :private_pem, limit: 64.kilobytes-1
      t.text :detail
      t.string :acme_id

      t.timestamps
    end
    add_index :projects, :name, unique: true
    add_index :projects, :email, unique: true
  end
end

class CreateCertificates < ActiveRecord::Migration[5.0]
  def change
    create_table :certificates do |t|
      t.string :cn, null: false
      t.text :last_crt, limit: 64.kilobytes-1
      t.text :csr, limit: 64.kilobytes-1
      t.text :key, limit: 16.kilobytes
      t.text :detail
      t.string :acme_id
      t.references :owner, foreign_key: { :on_update => :cascade, on_delete: :cascade }

      t.timestamps
    end
    add_index :certificates, :cn, unique: true
  end
end

class AddTimestampsToCertificates < ActiveRecord::Migration[5.0]
  def change
    add_column :certificates, :expired_at, :datetime
  end
end

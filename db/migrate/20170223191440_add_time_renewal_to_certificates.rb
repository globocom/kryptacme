class AddTimeRenewalToCertificates < ActiveRecord::Migration[5.0]
  def change
    add_column :certificates, :time_renewal, :int, :default => 30
  end
end

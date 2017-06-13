class ChangeCertificateColumnEnvironmentNull < ActiveRecord::Migration[5.0]
  def change
    change_column :certificates, :environment_id, :int, :null => true
  end
end

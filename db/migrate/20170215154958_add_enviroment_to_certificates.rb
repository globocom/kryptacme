class AddEnviromentToCertificates < ActiveRecord::Migration[5.0]
  def change
    add_reference :certificates, :environment, foreign_key: true
  end
end

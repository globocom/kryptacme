class CreateUserProjectJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_join_table :users, :projects do |t|
      # t.index [:user_id, :project_id]
      # t.index [:project_id, :user_id]
    end
  end
end

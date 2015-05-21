class DeleteMessage < ActiveRecord::Migration
  def change
	remove_column :users, :message
  end
end

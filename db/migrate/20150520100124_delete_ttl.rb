class DeleteTtl < ActiveRecord::Migration
  def change
	remove_column :users, :ttl
  end
end

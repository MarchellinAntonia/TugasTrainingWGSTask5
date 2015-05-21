class DeleteJeniskelamin < ActiveRecord::Migration
  def change
	remove_column :users, :jeniskelamin
  end
end

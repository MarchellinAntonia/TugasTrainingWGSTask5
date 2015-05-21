class RenameAlamatToAddress < ActiveRecord::Migration
  def change
	rename_column :users, :alamat, :address
  end
end

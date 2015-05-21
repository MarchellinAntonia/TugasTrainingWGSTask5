class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :ttl
      t.string :jeniskelamin
      t.string :alamat
      t.string :email
      t.string :message

      t.timestamps
    end
  end
end

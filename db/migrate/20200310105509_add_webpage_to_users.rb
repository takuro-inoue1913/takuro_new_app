class AddWebpageToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :webpage, :string
  end
end

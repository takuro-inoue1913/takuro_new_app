class AddSelfIntroductionUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :self_introduction, :string
  end
end

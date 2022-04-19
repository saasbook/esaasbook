class ChangeUserNames < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
      t.rename :full_name, :nickname
    end
  end
end

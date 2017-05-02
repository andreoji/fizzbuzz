class ChangeNumberTypeToInteger < ActiveRecord::Migration[5.0]
  def change
    change_column :favourites, :number, :integer
  end
end

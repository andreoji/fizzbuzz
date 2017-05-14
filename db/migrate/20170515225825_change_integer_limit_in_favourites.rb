class ChangeIntegerLimitInFavourites < ActiveRecord::Migration[5.0]
  def change
    change_column :favourites, :number, :integer, limit: 8
  end
end

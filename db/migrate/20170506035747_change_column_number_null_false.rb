class ChangeColumnNumberNullFalse < ActiveRecord::Migration[5.0]
  def change
    change_column_null :favourites, :number, false
  end
end

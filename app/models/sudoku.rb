class Sudoku < ApplicationRecord
  def get_value(id)
    @data[id]
  end
end

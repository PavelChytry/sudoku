class CreateSudokus < ActiveRecord::Migration[5.2]
  def change
    create_table :sudokus do |t|
      t.string :text
      t.string :data

      t.timestamps
    end
  end
end

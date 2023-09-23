class AddFieldsToModel < ActiveRecord::Migration[7.0]
  def change
    add_column :words, :sound, :string
    add_column :words, :explain, :string
    add_column :words, :example, :text
  end
end

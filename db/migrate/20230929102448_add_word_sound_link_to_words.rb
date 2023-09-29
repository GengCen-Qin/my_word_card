class AddWordSoundLinkToWords < ActiveRecord::Migration[7.0]
  def change
    add_column :words, :word_sound_link, :string
  end
end

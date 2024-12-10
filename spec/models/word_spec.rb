require 'rails_helper'

RSpec.describe Word, type: :model do
  context '增删改查' do
    let(:word) {
      Word.create(
      name: 'love',
      sound: '/lʌv/',
      explain: 'to have a strong feeling of affection for someone, combined with sexual attraction',
      example: 'I love you, Tracy.',
      word_sound_link: 'https://www.ldoceonline.com/media/english/breProns/brelasdelove.mp3?version=1.2.63')
    }

    it '创建' do
      expect(word).to be_valid
    end

    it '更新' do
      word.update(name: 'updated')
      expect(word.reload.name).to eq('updated')
    end

    it '删除' do
      word.destroy
      expect(Word.find_by(id: word.id)).to be_nil
    end

    it '查询' do
      found_word = Word.find(word.id)
      expect(found_word.name).to eq('love')
    end
  end
end

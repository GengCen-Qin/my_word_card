require "application_system_test_case"

class WordsTest < ApplicationSystemTestCase
  setup do
    @word = Word.ordered.first
  end

  test "Showing a quote" do
    visit words_path
    click_link @word.name

    assert_selector "h1", text: @word.name
  end

  test "Creating a new word" do
    visit words_path
    assert_selector "h1", text: "Words"

    click_on "New word"
    fill_in "Name", with: "Apple"

    assert_selector "h1", text: "Words"
    click_on "Create word"

    assert_selector "h1", text: "Words"
    assert_text "Apple"
  end

  test "Updating a word" do
    visit words_path
    assert_selector "h1", text: "Words"

    click_on "Edit", match: :first
    fill_in "Name", with: "Banana"

    assert_selector "h1", text: "Words"
    click_on "Update word"

    assert_selector "h1", text: "Words"
    assert_text "Banana"
  end

  test "Destroying a word" do
    visit words_path
    assert_text @word.name

    click_on "Delete", match: :first
    assert_no_text @word.name
  end

  test"searching a word" do

  end
end

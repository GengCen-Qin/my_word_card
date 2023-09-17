require "application_system_test_case"

class WordsTest < ApplicationSystemTestCase
  setup do
    @word = words(:first)
  end

  test "Create a new word" do
    visit words_path
    assert_selector "h1", text: "Words"

    click_on "New word"
    assert_selector "h1", text: "New word"

    fill_in "Name", with: "Apple"
    click_on "Create word"

    assert_selector "h1", text: "Words"
    assert_text "Apple"
  end

  test "Updating a word" do
    visit words_path
    assert_selector "h1", text: "Words"

    click_on "Edit", match: :first
    assert_selector "h1", text: "Edit word"

    fill_in "Name", with: "Banana"
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
end

require 'test_helper'

class CategoryTest <  ActiveSupport::TestCase
  def setup
    @category = Category.new(category_type:"Deluxe Rooms", facility:"Queen size Bed", price:7000)
  end

  test "Should be valid" do
    assert @category.valid?
  end

  test "category type should be present" do
    @category.category_type = " "
    assert_not @category.valid?
  end

  test "facilities should be present" do
    @category.facility = " "
    assert_not @category.valid?
  end

  test "price should be present" do
    @category.price = nil
    assert_not @category.valid?
  end

  test "price should be numeric" do
    @category.price = "abcde"
    assert_not @category.valid?
  end
end
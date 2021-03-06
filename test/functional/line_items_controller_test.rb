require 'test_helper'

class LineItemsControllerTest < ActionController::TestCase
  setup do
    @line_item = line_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns :line_items
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should decrement line_item" do
    post :decrement, :id => @line_item
    assert_redirected_to store_path
    assert_equal(assigns(:line_item).quantity, line_items(:one).quantity)
  end

  test "should decrement line_item via ajax" do
    xhr :put, :decrement, :id => @line_item

    assert_select_jquery(:html, '#cart') do
      # breaks if product title contains apostrophes and other html entities
      # look for <td>1x</td> after the 2 line items is decremented to just 1
      assert_select 'tr#current_item td', /1&times;/
    end
  end

  test "should create line_item" do
    assert_difference 'LineItem.count' do
      post :create, :product_id => products(:catsCradle).id
    end

    assert_redirected_to store_path
  end

  test "should create line_item via ajax" do
    assert_difference 'LineItem.count' do
      xhr :post, :create, :product_id => products(:theNameOfTheWind).id
    end

    assert_response :success
    assert_select_jquery(:html, '#cart') do
      # breaks if product title contains apostrophes and other html entities
      assert_select 'tr#current_item td', /#{products(:theNameOfTheWind).title}/
    end
  end

  test "should show line_item" do
    get :show, :id => @line_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @line_item
    assert_response :success
  end

  test "should update line_item" do
    put :update, :id => @line_item, :line_item => { :cart_id => @line_item.cart_id, :product_id => @line_item.product_id }
    assert_redirected_to line_item_path(assigns(:line_item))
  end

  test "should destroy line_item" do
    assert_difference('LineItem.count', -1) do
      delete :destroy, :id => @line_item
    end

    assert_redirected_to line_items_path
  end

  test "should raise exception on line item mass update" do
    params = {
        :line_item => {
            :cart_id => @line_item.cart_id,
            :product_id => @line_item.product_id
        }
    }
    assert_raise ActiveModel::MassAssignmentSecurity::Error do
      @line_item.update_attributes(params[:line_item])
    end
  end
end

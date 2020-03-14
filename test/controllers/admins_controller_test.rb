require 'test_helper'

class AdminsControllerTest < ActionDispatch::IntegrationTest
  test "should get login_form" do
    get admins_login_form_url
    assert_response :success
  end

end

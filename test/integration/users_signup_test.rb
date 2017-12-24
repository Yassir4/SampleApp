require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  

  
  test "invalid signup information" do
     # the main reason of this testis that User.count before and after  the failed signup below are equal "assert_no_difference".
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                     email: "user@invalid",
                                     password:              "foo",
                                     password_confirmation: "bar" } }
    end
    
    assert_template 'users/new'
    assert_select "li" , "Password is too short (minimum is 6 characters)"
    assert_select "li" , "Password confirmation doesn't match Password"
    assert_select "div#error_explanation"
    
  end
  
   test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
  end  
  
end

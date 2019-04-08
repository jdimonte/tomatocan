require 'test_helper'
class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
   # sign_in @user
  end

  test "should equate youtube field" do
    youtube="youtube"
    assert_equal(youtube,@user.youtube)
  end

  test "should get users youtubers" do
    get :youtubers
    assert_response :success
  end
#Ambiguous method checking


  test "should recognize youtubers"do
    assert_recognizes({controller: 'users',action:'youtubers'},'youtubers')
  end

  test "should get users support our work" do
    get :supportourwork
    assert_response :success
  end

  test "should recognize supportourwork"do
    assert_recognizes({controller: 'users',action:'supportourwork'},'supportourwork')
  end
  test "should recognize users dashboard logged in"do
    assert_recognizes({controller: 'users',action:'dashboard',permalink:'user1'},'user1/dashboard')
  end
  
  test "should get users dashboard logged in" do
    sign_in @user
    @book = books(:one)
    @purchase = purchases(:one)
 #   puts @book.id
 #   puts "Notice that the book id is some ridiculously huge integer."
    get :dashboard, params: {permalink: 'user1'}
    assert_response :success
  end

  test "should not get users dashboard logged out" do
    sign_in @user
    @book = books(:one)
    @purchase = purchases(:one)
 #   puts @book.id
 #   puts "Notice that the book id is some ridiculously huge integer."
    get :dashboard, params: {permalink: 'user2'}
    assert_response :success
  end
 
  test "should get control panel logged in" do
    sign_in @user
    @book = books(:one)
    @purchase = purchases(:one)
 #   puts @book.id
 #   puts "Notice that the book id is some ridiculously huge integer."
    get :controlpanel, params: {permalink: 'user1',id: @user.id} 
    assert_response :success

    end 
   
  test "should get users eventlist user logged in" do
    get :eventlist, params: {permalink: 'user1'}
    assert_response :success
  end

  test "should get users eventlist user not logged in" do 
    #what's the difference in expected result compared to logged in? Do we care?
    get :eventlist, params: {permalink: 'user2'}
    assert_response :success
  end

  test "should get changepassword" do
    get :changepassword, params: {permalink: 'user1'}
    assert_response :success
  end
   
  test "should get pastevents logged in" do
    sign_in @user
    user=User.find_by_permalink(@user.permalink)
    get :pastevents, params: {permalink: 'user1'}
    assert_response :success
  end
  test "should recognize pastevents" do
    get :pastevents, params: {permalink: 'user1'}
    assert_recognizes({controller: 'users',action:'pastevents', permalink:'user1'},'user1/pastevents')
  end
  test "should get pastevents not logged in" do
     get :pastevents, params: {permalink: 'user2'}
    assert_response :success
  end

  test "should get users profileinfo" do 
    get :profileinfo, params: {permalink: 'user1'}
    assert_response :success
  end

  test "should get users show" do #user1 has phases
    get :show, params: {permalink: 'user1'}
    assert_response :success
  end

  test "should create user" do #rails test test/controllers/users_controller_test.rb -n test_should_equate_youtube_field; To test whether address/zip from IP is saved, need to test registrations controller. But can't do on localhost.
    assert_difference('User.count', 1) do
      post :create, params: { user: { name: 'samiam', email: 'fakeunique@fake.com', password: 'secret12', password_confirmation: 'secret12', permalink: 'samlink' } }
    end
   end
 
 test "should redirect new user" do # To test whether address/zip from IP is saved, need to test registrations controller. But can't do on localhost.
    post :create, params: { user: { name: 'samiam', email: 'fakeunique@fake.com', password: 'secret12', password_confirmation: 'secret12', permalink: 'samlink' } }
    assert_redirected_to (user_profileinfo_path(assigns(:user).permalink))
  end

  test "should show user profile" do #user2 has no phases
    get :show, params: {permalink: 'user2' }
    assert_response :success
  end


  test "should update user" do
    sign_in @user
    patch :update, params: { id: @user.id, user: { name: 'New Name', youtube1: 'randomchar' } }
    user = User.find_by_permalink(@user.permalink)
    assert_equal(user.name, "New Name")
  end

  test "should redirect to user" do
    sign_in @user
    patch :update, params: { id: @user.id, user: { name: 'New Name', youtube1: 'randomchar' } }
    user = User.find_by_permalink(@user.permalink)
    assert_redirected_to user_profile_path(user.permalink)
  end;

#this part added
  test "should verify user twitter" do
 sign_in @user
	patch :update, params:{ id: @user.id, user: {name: 'Phineas', password: 'p', password_confirmation: 'p',
    twitter: 'MyTwitter', email: 'fake@fake.com', permalink: 'user1'}}
  assert_equal "MyTwitter", @user.twitter

  end
end

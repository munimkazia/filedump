require 'test_helper'

class UploadsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  test 'should get new page for logged out users' do 
    get :new
    assert_response :success
    assert_nil assigns(:current_user)
    assert_nil assigns(:user_signed_in?)
  end

  test 'should not allow logged out users to upload' do
    uploaded = fixture_file_upload('files/file1', 'text/plain')
    post :create, upload: { upload: uploaded }
    assert_response :unauthorized
  end

  test 'should not allow logged out users to download' do 
    @user = User.find_by(email: 'user2@test.com')
    sign_in @user
    uploaded = fixture_file_upload('files/file1', 'text/plain')
    post :create, upload: { upload: uploaded }
    sign_out @user

    upload =  Upload.limit(1)
    get :show, id: upload[0]["id"]
    assert_response :unauthorized
    sign_out @user
  end

  test 'should not allow logged out users to delete' do 
    @user = User.find_by(email: 'user2@test.com')
    sign_in @user
    uploaded = fixture_file_upload('files/file1', 'text/plain')
    post :create, upload: { upload: uploaded }
    sign_out @user

    upload =  Upload.limit(1)
    post :destroy, id: upload[0]["id"]
    assert_response :unauthorized
    sign_out @user
  end

  test 'should get new page for logged in users' do
    @user = User.find_by(email: 'user1@test.com')
    sign_in @user
    get :new
    assert_response :success
    assert_equal assigns(:current_user)['email'], @user.email
    assert_equal assigns(:user_signed_in), true
    assert_equal assigns(:current_user)['admin'], 0
    sign_out @user
  end

  test 'should allow logged in users to upload' do 
    uploaded = fixture_file_upload('files/file1', 'text/plain')
    @user = User.find_by(email: 'user1@test.com')
    sign_in @user
    post :create, upload: { upload: uploaded }
    assert_response :redirect
    sign_out @user
  end
  
  test 'should allow logged in users to download' do 
    @user = User.find_by(email: 'user2@test.com')
    sign_in @user
    uploaded = fixture_file_upload('files/file1', 'text/plain')
    post :create, upload: { upload: uploaded }
    sign_out @user

    @user = User.find_by(email: 'user1@test.com')
    sign_in @user
    upload =  Upload.limit(1)
    get :show, id: upload[0]["id"]
    assert_response :success
    sign_out @user
  end

  test 'should allow owners to delete their own files' do
    @user = User.find_by(email: 'user2@test.com')
    sign_in @user
    uploaded = fixture_file_upload('files/file1', 'text/plain')
    post :create, upload: { upload: uploaded }
    
    upload =  Upload.limit(1)
    post :destroy, id: upload[0]["id"]
    assert_response :redirect
    sign_out @user
  end

  test 'should not allow users to delete files not owned by them' do
    @user = User.find_by(email: 'user2@test.com')
    sign_in @user
    uploaded = fixture_file_upload('files/file1', 'text/plain')
    post :create, upload: { upload: uploaded }
    sign_out @user

    @user = User.find_by(email: 'user1@test.com')
    sign_in @user
    upload =  Upload.limit(1)
    post :destroy, id: upload[0]["id"]
    assert_response :forbidden
    sign_out @user
  end

  test 'should allow admin users to delete anything' do
    @user = User.find_by(email: 'user2@test.com')
    sign_in @user
    uploaded = fixture_file_upload('files/file1', 'text/plain')
    post :create, upload: { upload: uploaded }
    sign_out @user

    @user = User.find_by(email: 'admin@test.com')
    sign_in @user
    upload =  Upload.limit(1)
    post :destroy, id: upload[0]["id"]
    assert_response :redirect
    sign_out @user
  end

end

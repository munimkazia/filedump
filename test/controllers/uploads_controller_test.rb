require 'test_helper'

class UploadsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  test 'should get new page for logged out users' do 
    get :new
    assert_response :success
    assert_nil assigns(:current_user)
    assert_nil assigns(:user_signed_in?)
    assert_select 'tr.uploadrow', 0
  end

  test 'should not allow logged out users to upload' do
    uploaded = fixture_file_upload('files/file1', 'text/plain')
    post :create, upload: { upload: uploaded }
    assert_response :unauthorized
  end

  test 'should not allow logged out users to download' do 
    sign_in users(:two)
    uploaded = fixture_file_upload('files/file1', 'text/plain')
    post :create, upload: { upload: uploaded }
    sign_out users(:two)

    upload =  Upload.limit(1)
    get :show, id: upload[0]["id"]
    assert_response :unauthorized
  end

  test 'should not allow logged out users to delete' do 
    sign_in users(:two)
    uploaded = fixture_file_upload('files/file1', 'text/plain')
    post :create, upload: { upload: uploaded }
    sign_out users(:two)

    upload =  Upload.limit(1)
    post :destroy, id: upload[0]["id"]
    assert_response :unauthorized

    sign_in users(:two)
    get :new
    assert_select 'tr.uploadrow', 1
    sign_out users(:two)
  end

  test 'should get new page for logged in users' do
    sign_in users(:one)
    get :new
    assert_response :success
    assert_equal assigns(:current_user)['email'], users(:one)["email"]
    assert_equal assigns(:user_signed_in), true
    assert_equal assigns(:current_user)['admin'], 0
    assert_select 'tr.uploadrow', 0
    sign_out users(:one)
  end

  test 'should allow logged in users to upload' do 
    uploaded = fixture_file_upload('files/file1', 'text/plain')
    sign_in users(:one)
    post :create, upload: { upload: uploaded }
    assert_response :redirect

    get :new
    assert_select 'tr.uploadrow', 1

    sign_out users(:one)
  end
  
  test 'should allow logged in users to download' do 
    sign_in users(:two)
    uploaded = fixture_file_upload('files/file1', 'text/plain')
    post :create, upload: { upload: uploaded }
    sign_out users(:two)

    sign_in users(:one)
    upload =  Upload.limit(1)
    get :show, id: upload[0]["id"]
    assert_response :success
    sign_out users(:one)
  end

  test 'should allow owners to delete their own files' do
    sign_in users(:two)
    uploaded = fixture_file_upload('files/file1', 'text/plain')
    post :create, upload: { upload: uploaded }
    
    upload =  Upload.limit(1)
    post :destroy, id: upload[0]["id"]
    assert_response :redirect

    get :new
    assert_select 'tr.uploadrow', 0
    sign_out users(:two)
  end

  test 'should not allow users to delete files not owned by them' do
    sign_in users(:two)
    uploaded = fixture_file_upload('files/file1', 'text/plain')
    post :create, upload: { upload: uploaded }
    sign_out users(:two)

    sign_in users(:one)
    upload =  Upload.limit(1)
    post :destroy, id: upload[0]["id"]
    assert_response :forbidden

    get :new
    assert_select 'tr.uploadrow', 1
    sign_out users(:one)
  end

  test 'should allow admin users to delete anything' do
    sign_in users(:one)
    uploaded = fixture_file_upload('files/file1', 'text/plain')
    post :create, upload: { upload: uploaded }
    sign_out users(:one)

    sign_in users(:admin)
    upload =  Upload.limit(1)
    post :destroy, id: upload[0]["id"]
    assert_response :redirect

    get :new
    assert_select 'tr.uploadrow', 0
    sign_out users(:admin)
  end

end

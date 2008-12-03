require File.join( File.dirname(__FILE__), '..', 'spec_helper' )
require File.join(File.expand_path(File.dirname(__FILE__)), "..", ".." ,"merb", "merb-auth", "mixins", "rpx_user")
require File.join(File.expand_path(File.dirname(__FILE__)), "..", ".." ,"merb", "merb-auth", "rpx_client")
require 'net/http'

describe "An Rpx User" do
  
  before(:all) do
    # DataMapper.setup(:default, "sqlite3::memory:")
    # 
    # class RpxUser
    #   include DataMapper::Resource
    #   include Merb::Authentication::Mixins::RpxUser
    #   
    #   property :id, Serial
    #   property :first_name,  String
    #   property :identity_url,  String      
    # end
    # RpxUser.auto_migrate!
    
    Net::HTTP.any_instance.stubs(:post).returns('')
  end
  
  after(:each) do
    User.all.destroy!
  end
  
  def default_user_params
    {:first_name => "fred", :identity_url => "http://fred.example.com"}
  end
  
  def good_rpx_response
    msg = %q{
      {
        "profile": {
          "preferredUsername": "brian",
          "displayName": "brian",
          "url": "http:\/\/brian.myopenid.com\/",
          "identifier": "http:\/\/brian.myopenid.com\/"
        },
        "stat": "ok"
      } 
    }.strip
    Struct.new(:code, :body).new('200', msg)
  end
  
  def bad_rpx_response
    msg = %q{
      {
        "err": {
          "msg": "Data not found",
          "code": 2
        },
        "stat": "fail"
      }
    }.strip
    
    Struct.new(:code, :body).new('200', msg)
  end
    
  before(:each) do
    @user = User.new
  end
  
  it "should have an identity_url property" do
    @user.should respond_to(:identity_url)
  end
  
  it "should authenticate by returning a user object in a block given rpxnow successfully authenticates the user" do
    Net::HTTP.any_instance.expects(:post).returns(good_rpx_response)
    User.authenticate_via_rpx!('someapitoken', 'sometoken') do |user|      
      user.should_not be_nil
      user.should be_a_kind_of(User)      
    end
  end
  
  it "should create a new user from responses identifier if none existant given rpxnow successfully authenticates the user" do
    Net::HTTP.any_instance.expects(:post).returns(good_rpx_response)
    User.first(:identity_url => 'http://brian.myopenid.com/').should be_nil
    User.authenticate_via_rpx!('someapitoken', 'sometoken') do |user|
      user.new_record?.should be_false
      user.identity_url.should == 'http://brian.myopenid.com/'
    end
  end
  
  it "should only return the exisiting user given rpxnow successfully authenticates the user" do
    Net::HTTP.any_instance.expects(:post).returns(good_rpx_response)
    existing_user = User.new(:identity_url => 'http://brian.myopenid.com/')
    existing_user.save(:rpx).should be_true
    User.expects(:new).never
    User.authenticate_via_rpx!('someapitoken', 'sometoken') do |user|
      user.new_record?.should be_false
      user.should == existing_user
    end
  end
  
  it "should not authenticate given rpxnow did not authenticate the user" do
    Net::HTTP.any_instance.expects(:post).returns(bad_rpx_response)
    User.authenticate_via_rpx!('someapitoken', 'sometoken') do |error_message|
      error_message.should be_a_kind_of(Hash)
      error_message['stat'].should == 'fail'
      error_message['err']['msg'].should == 'Data not found'
      error_message['err']['code'].should == 2
    end
  end
  
end
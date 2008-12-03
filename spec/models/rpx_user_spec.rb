require File.join( File.dirname(__FILE__), '..', 'spec_helper' )
require 'dm-core'
require 'dm-validations'
require File.join(File.expand_path(File.dirname(__FILE__)), "..", ".." ,"merb", "merb-auth", "mixins", "rpx_user")

describe "An Rpx User" do
  
  before(:all) do
    DataMapper.setup(:default, "sqlite3::memory:")
    
    class RpxUser
      include DataMapper::Resource
      include Merb::Authentication::Mixins::RpxUser
      
      property :id, Serial
      property :email, String
      property :first_name,  String
      property :identity_url,  String      
    end
    RpxUser.auto_migrate!
  end
  
  after(:each) do
    RpxUser.all.destroy!
  end
  
  def default_user_params
    {:first_name => "fred", :identity_url => "http://fred.example.com"}
  end
  
  it "should have tests"
end
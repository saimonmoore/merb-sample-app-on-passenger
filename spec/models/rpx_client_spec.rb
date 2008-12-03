require File.join( File.dirname(__FILE__), '..', 'spec_helper' )
require File.join(File.expand_path(File.dirname(__FILE__)), "..", ".." ,"merb", "merb-auth", "rpx_client")
require 'net/http'

describe "The RpxClient" do
  
  before(:all) do
    Net::HTTP.any_instance.stubs(:post).returns('')
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
  
  it "should convert response from json to a hash" do
    Net::HTTP.any_instance.expects(:post).returns(good_rpx_response)
    rpx_client.auth_info('sometoken').should be_a_kind_of(Hash)
  end
    
  def rpx_client
    RpxClient.new('someapikey')
  end
end
require File.join( File.dirname(__FILE__), '..', 'spec_helper' )
require File.join(File.expand_path(File.dirname(__FILE__)), "..", ".." ,"merb", "merb-auth", "rpx_client")

describe "The RpxClient" do
  
  before(:all) do
    RpxClient.any_instance.stubs(:get_response).returns('')
  end
      
  def good_rpx_response
    %q{
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
  end
  
  def bad_rpx_response
    %q{
      {
        "err": {
          "msg": "Data not found",
          "code": 2
        },
        "stat": "fail"
      }
    }.strip
  end
  
  it "should convert response from json to a hash" do
    RpxClient.any_instance.expects(:get_response).returns(good_rpx_response)
    rpx_client.data.should be_a_kind_of(Hash)
  end
    
  def rpx_client
    RpxClient.new('someapikey', 'sometoken')
  end
end
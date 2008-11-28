require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Post do
  before(:each) do
    @post = Post.new
  end

  it "should not be valid without a title or a body" do
    @post.should_not be_valid
  end
    
  it "should not be valid without a title" do
    @post.body = "some body"
    @post.should_not be_valid
  end
  
  it "should not be valid without a body" do
    @post.title = "some title"    
    @post.should_not be_valid
  end
  
  it "should be valid with a title and a body" do
    @post.title = "some title"    
    @post.body = "some body"    
    @post.should be_valid
  end

end
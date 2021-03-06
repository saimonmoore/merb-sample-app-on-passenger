require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a post exists" do
  Post.all.destroy!
  login
  request(resource(:posts), :method => "POST", 
    :params => { :post => { :title => 'bla', :body => 'bla bla' }})
end

describe "resource(:posts)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:posts))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of posts" do
      @response.should have_xpath("//ol")
    end
    
  end
  
  describe "GET", :given => "a post exists" do
    before(:each) do
      @response = request(resource(:posts))
    end
    
    it "has a list of posts" do
      @response.should have_xpath("//ol/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Post.all.destroy!
      login
      @response = request(resource(:posts), :method => "POST", 
        :params => { :post => { :title => 'bla', :body => 'bla bla' }})
    end
    
    it "redirects to resource(:posts)" do
      @response.should redirect_to(resource(Post.first), :message => {:notice => "post was successfully created"})
    end
    
  end
end

describe "resource(@post)" do 
  describe "a successful DELETE", :given => "a post exists" do
     before(:each) do
       login
       @response = request(resource(Post.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:posts))
     end

   end
end

describe "resource(:posts, :new)" do
  before(:each) do
    login
    @response = request(resource(:posts, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@post, :edit)", :given => "a post exists" do
  before(:each) do
    login
    @response = request(resource(Post.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@post)", :given => "a post exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Post.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      login
      @post = Post.first
      @response = request(resource(@post), :method => "PUT", 
        :params => { :post => {:id => @post.id, :title => 'blas', :body => 'blas blas'} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@post))
    end
  end
  
end


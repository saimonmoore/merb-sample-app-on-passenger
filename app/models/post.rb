class Post
  include DataMapper::Resource
  
  property :id, Serial
  
  property :body, Text, :nullable => false
  property :title, String, :nullable => false

  property :created_at, DateTime  
  property :updated_at, DateTime
  property :created_on, Date
  property :updated_on, Date

  belongs_to :user

  # No need for these, as they are implicit due to the nullable option  
  # validates_present :title
  # validates_present :body
end

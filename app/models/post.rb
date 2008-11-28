class Post
  include DataMapper::Resource
  
  property :id, Serial
  
  property :body, Text
  property :title, String

  property :created_at, DateTime  
  property :updated_at, DateTime
  property :created_on, Date
  property :updated_on, Date

  belongs_to :user
  
  validates_present :title
  validates_present :body
end

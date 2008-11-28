class Posts < Application
  # provides :xml, :yaml, :js

  def index
    @posts = Post.all
    display @posts
  end

  def show(id)
    @post = Post.get(id)
    raise NotFound unless @post
    display @post
  end

  def new
    only_provides :html
    @post = Post.new
    display @post
  end

  def edit(id)
    only_provides :html
    @post = Post.get(id)
    raise NotFound unless @post
    display @post
  end

  def create(post)
    @post = Post.new(post)
    if @post.save
      redirect resource(@post), :message => {:notice => "Post was successfully created"}
    else
      message[:error] = "Post failed to be created"
      render :new
    end
  end

  def update(id, post)
    @post = Post.get(id)
    raise NotFound unless @post
    if @post.update_attributes(post)
       redirect resource(@post)
    else
      display @post, :edit
    end
  end

  def destroy(id)
    @post = Post.get(id)
    raise NotFound unless @post
    if @post.destroy
      redirect resource(:posts)
    else
      raise InternalServerError
    end
  end

end # Posts

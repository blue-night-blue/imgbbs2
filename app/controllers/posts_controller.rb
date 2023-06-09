class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy like ]

  # GET /posts or /posts.json
  def index
    @posts = Post.all.order(created_at: :desc)
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(image_resize(post_params))

    respond_to do |format|
      if @post.save
        format.html { redirect_to root_path}
        format.json { render :index, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # like 
  def like
    if @post.like==nil
      @post.like=1
    else
      @post.like+=1
    end

    respond_to do |format|
      if @post.save
        format.html { redirect_to request.referer }
        format.json { render :index, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  
  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(image_resize(post_params))
        format.html { redirect_to root_path, notice: "Post was successfully updated." }
        format.json { render :index, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to request.referer, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  
  
  
  

  def tag
    @tag=params[:tag]
    @posts=Post.where("tag LIKE ?","%#{@tag}%").order(created_at: :desc) 
  end 
  
  
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:name, :content, :tag, :image)
    end

    def image_resize(params)
      if params[:image]
        params[:image].tempfile = ImageProcessing::MiniMagick
          .source(params[:image].tempfile)
          .resize_to_limit(1024, 768)
          .strip
          .call
      end
      params
    end 
    
end

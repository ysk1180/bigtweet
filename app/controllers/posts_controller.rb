class PostsController < ApplicationController
  before_action :set_post, only: [:confirm, :edit, :update, :show]
  before_action :new_post, only: [:show, :new]

  def show
    render :new
  end

  def confirm
  end

  def new
  end

  def update
    if @post.update(post_params)
      make_picture(@post.id)
      redirect_to confirm_path(@post)
    else
      render :edit
    end
  end

  def create
    @post = Post.new(post_params)
    next_id = Post.last.id + 1
    make_picture(next_id)
    if @post.save
      redirect_to confirm_path(@post)
    else
      render :new
    end
  end

  private
  def set_post
    @post = Post.find(params[:id])
  end

  def new_post
    @post = Post.new
  end

  def post_params
    params.require(:post).permit(:power, :picture, :kind)
  end

  def make_picture(next_id)
    sentense = ""
    content = @post.power.gsub(/\r\n|\r|\n/," ")
    if content.length <= 50 then
      n = (content.length / 10).floor + 1
      n.times do |i|
        s_num = i * 10
        f_num = s_num + 9
        range =  Range.new(s_num,f_num)
        sentense += content.slice(range)
        sentense += "\n" if n != i+1
      end
      pointsize = 60
    else
      n = (content.length / 15).floor + 1
      n.times do |i|
        s_num = i * 15
        f_num = s_num + 14
        range =  Range.new(s_num,f_num)
        sentense += content.slice(range)
        sentense += "\n" if n != i+1
      end
      pointsize = 45
    end
    font = ".fonts/Jiyucho.ttf"
    case @post.kind
    when "thunder" then
      base = "thunder.png"
      color = "white"
    when "muscle" then
      base = "muscle.png"
      color = "black"
    when "cat" then
      base = "cat.png"
      color = "white"
    when "love" then
      base = "love.png"
      color = "white"
    when "shock" then
      base = "shock.png"
      color = "white"
    when "fuck" then
      base = "fuck.png"
      color = "white"
    when "lion" then
      base = "lion.png"
      color = "white"
    when "balloon" then
      base = "balloon.png"
      color = "black"
    when "happy" then
      base = "happy.png"
      color = "black"
    when "old" then
      base = "old.png"
      color = "white"
    when "people" then
      base = "people.png"
      color = "white"
    when "star" then
      base = "star.png"
      color = "white"
    when "sunset" then
      base = "sunset.png"
      color = "white"
    else
      base = "fire.png"
      color = "white"
    end
    image = MiniMagick::Image.open(base)
    image.combine_options do |i|
      i.font font
      i.fill color
      i.gravity 'center'
      i.pointsize pointsize
      i.draw "text 0,0 '#{sentense}'"
    end
    storage = Fog::Storage.new(
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: 'ap-northeast-1'
    )
    case Rails.env
      when 'production'
        bucket = storage.directories.get('bigtweet-production')
        png_path = 'images/' + next_id.to_s + '.png'
        image_uri = image.path
        file = bucket.files.create(key: png_path, public: true, body: open(image_uri))
        @post.picture = 'https://s3-ap-northeast-1.amazonaws.com/bigtweet-production' + "/" + png_path
      when 'development'
        bucket = storage.directories.get('bigtweet-development')
        png_path = 'images/' + next_id.to_s + '.png'
        image_uri = image.path
        file = bucket.files.create(key: png_path, public: true, body: open(image_uri))
        @post.picture = 'https://s3-ap-northeast-1.amazonaws.com/bigtweet-development' + "/" + png_path
    end
  end
end

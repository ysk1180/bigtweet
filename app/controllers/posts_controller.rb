class PostsController < ApplicationController
  before_action :set_post, only: [:confirm, :edit, :update]
  before_action :new_post, only: [:show, :new]

  def show
    @post.id = params[:id]
    render :new
  end

  def confirm
  end

  def new
  end

  def edit
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
    params.require(:post).permit(:power, :kind)
  end

  def make_picture(id)
    sentense = ""
    content = @post.power.gsub(/\r\n|\r|\n/," ")
    if content.length <= 28 then
      n = (content.length / 7).floor + 1
      n.times do |i|
        s_num = i * 7
        f_num = s_num + 6
        range =  Range.new(s_num,f_num)
        sentense += content.slice(range)
        sentense += "\n" if n != i+1
      end
      pointsize = 90
    elsif content.length <= 50 then
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
    color = "white"
    draw = "text 0,0 '#{sentense}'"
    font = ".fonts/GenEiGothicN-U-KL.otf"
    case @post.kind
    when "thunder" then
      base = "app/assets/images/thunder.png"
    when "muscle" then
      base = "app/assets/images/muscle.png"
      color = "black"
    when "cat" then
      base = "app/assets/images/cat.png"
    when "love" then
      base = "app/assets/images/love.png"
    when "shock" then
      base = "app/assets/images/shock.png"
    when "fuck" then
      base = "app/assets/images/fuck.png"
    when "lion" then
      base = "app/assets/images/lion.png"
    when "balloon" then
      base = "app/assets/images/balloon.png"
      color = "black"
    when "happy" then
      base = "app/assets/images/happy.png"
      color = "black"
    when "old" then
      base = "app/assets/images/old.png"
    when "people" then
      base = "app/assets/images/people.png"
    when "star" then
      base = "app/assets/images/star.png"
    when "sunset" then
      base = "app/assets/images/sunset.png"
    when "panic" then
      base = "app/assets/images/panic.jpg"
      color = "black"
      draw = "text -120,0 '#{sentense}'"
    when "joy1" then
      base = "app/assets/images/joy1.jpg"
      color = "black"
      draw = "text 0,-115 '#{sentense}'"
    when "joy2" then
      base = "app/assets/images/joy2.jpg"
      color = "black"
      draw = "text -130,-30 '#{sentense}'"
    when "joy3" then
      base = "app/assets/images/joy3.jpg"
      draw = "text -145,-35 '#{sentense}'"
    when "joy4" then
      base = "app/assets/images/joy4.jpg"
      color = "black"
      draw = "text -130,-10 '#{sentense}'"
    when "wow" then
      base = "app/assets/images/wow.jpg"
      draw = "text -125,-10 '#{sentense}'"
    when "cow" then
      base = "app/assets/images/cow.jpg"
      draw = "text -130,0 '#{sentense}'"
    when "think" then
      base = "app/assets/images/think.jpg"
      draw = "text 110,-10 '#{sentense}'"
    when "black" then
      base = "app/assets/images/black.jpg"
      pointsize += 30
    when "brown" then
      base = "app/assets/images/brown.jpg"
      pointsize += 30
    when "darkblue" then
      base = "app/assets/images/darkblue.jpg"
      pointsize += 30
    when "purple" then
      base = "app/assets/images/purple.jpg"
      pointsize += 30
    when "red" then
      base = "app/assets/images/red.jpg"
      pointsize += 30
    when "lightgreen" then
      base = "app/assets/images/lightgreen.jpg"
      color = "black"
      pointsize += 30
    when "pink" then
      base = "app/assets/images/pink.jpg"
      color = "black"
      pointsize += 30
    when "skyblue" then
      base = "app/assets/images/skyblue.jpg"
      color = "black"
      pointsize += 30
    when "white" then
      base = "app/assets/images/white.jpg"
      color = "black"
      pointsize += 30
    when "yellow" then
      base = "app/assets/images/yellow.jpg"
      color = "black"
      pointsize += 30
    else
      base = "app/assets/images/fire.png"
    end
    image = MiniMagick::Image.open(base)
    image.combine_options do |i|
      i.font font
      i.fill color
      i.gravity 'center'
      i.pointsize pointsize
      i.draw draw
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
        png_path = 'images/' + id.to_s + '.png'
        image_uri = image.path
        file = bucket.files.create(key: png_path, public: true, body: open(image_uri))
        @post.picture = 'https://s3-ap-northeast-1.amazonaws.com/bigtweet-production' + "/" + png_path
      when 'development'
        bucket = storage.directories.get('bigtweet-development')
        png_path = 'images/' + id.to_s + '.png'
        image_uri = image.path
        file = bucket.files.create(key: png_path, public: true, body: open(image_uri))
        @post.picture = 'https://s3-ap-northeast-1.amazonaws.com/bigtweet-development' + "/" + png_path
    end
  end
end

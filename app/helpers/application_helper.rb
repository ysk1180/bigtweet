module ApplicationHelper
  def get_twitter_card_info(post)
    twitter_card = {}
    if post
      twitter_card[:url] = "https://bigtweet.herokuapp.com/posts/#{post.id}"
      twitter_card[:image] = "https://s3-ap-northeast-1.amazonaws.com/bigtweet-production/images/#{post.id}.png"
    else
      twitter_card[:url] = 'https://bigtweet.herokuapp.com/'
      twitter_card[:image] = "https://raw.githubusercontent.com/ysk1180/bigtweet/master/app/assets/images/top.png"
    end
    twitter_card[:title] = "BigTweet"
    twitter_card[:card] = 'summary_large_image'
    twitter_card[:description] = '会員登録不要で、文字が入った画像を自動生成し、画像付きツイートが気軽にできるサービスです'
    twitter_card
  end
end

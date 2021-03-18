require 'rails_helper'

RSpec.describe "Comments", type: :system do
  before do
    @comment = Faker::Lorem.sentence
    @tweet = FactoryBot.create(:tweet)
  end

  context 'コメント投稿できるとき' do
    it 'ログインしたユーザーはツイート詳細ページでコメント投稿できる' do
      # ログインする
      sign_in(@tweet.user)
      # ツイート詳細ページに遷移する
      visit tweet_path(@tweet.id)
      # フォームに情報を入力する
      fill_in 'comment_text', with: @comment
      # コメントを送信すると、Commentモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change{Comment.count}.by(1)
      # 詳細ページにリダイレクトされることを確認する
      expect(current_path).to eq(tweet_path(@tweet.id))
      # 詳細ページ上に先程のコメント内容が含まれていることを確認する
      expect(page).to have_content(@comment)
    end
  end
end

require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  context 'ユーザー新規登録できるとき' do
    it '正しい情報を入力すればユーザー新規登録ができてトップページに遷移する' do
      # トップページに遷移する
      visit root_path
      # トップページに新規登録ボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ遷移する
      visit new_user_registration_path
      # 正しいユーザー情報を入力する
      fill_in 'Nickname', with: @user.nickname
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      fill_in 'Password confirmation', with: @user.password_confirmation
      # 新規登録するとユーザーモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change{ User.count }.by(1)
      # トップページに遷移したことを確認する
      expect(current_path).to eq(root_path)
      # カーソルを合わせるとログアウトボタンが表示されることを確認する
      expect(
        find('.user_nav').find('span').hover
      ).to have_content('ログアウト')
      # 新規登録ページに遷移するボタンや、ログインページへ遷移するボタンが表示されていることを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end

  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページに戻ってくる' do
      # トップページに遷移する
      visit root_path
      # トップページに新規登録ボタンがあることを確認する
      expect(page).to have_content("新規登録")
      # 新規登録ページへ遷移する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'Nickname', with: ""
      fill_in 'Email', with: ""
      fill_in 'Password', with: ""
      fill_in 'Password confirmation', with: ""
      # 新規登録してもユーザーモデルのカウントが上がらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { User.count}.by(0)
      # 新規登録ページへ戻されることを確認する
      expect(current_path).to eq('/users')
    end
  end
end

RSpec.describe 'ログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  context 'ログインできるとき' do
    it '保存されているユーザーの情報と合致すればログインできる' do
      # トップページに遷移する
      visit root_path
      # トップページにログインボタンがあることを確認する
      expect(page).to have_content("ログイン")
      # ログインページに遷移する
      visit new_user_session_path
      # 正しいユーザー情報を入力する
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページに遷移することを確認する
      expect(current_path).to eq (root_path)
      # カーソルを合わせるとログアウトボタンが表示されることを確認する
      expect(
        find('.user_nav').find('span').hover
      ).to have_content('ログアウト')
      # 新規登録ボタンやログインボタンが表示されていないことを確認する
      expect(page).to have_no_content("新規登録")
      expect(page).to have_no_content("ログイン")
    end
  end

  context 'ログインできないとき' do
    it '保存されているユーザーの情報と合致しないとログインできない' do
      # トップページに遷移する
      visit root_path
      # トップページにログインボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページに遷移する
      visit new_user_session_path
      # ユーザー情報を入力する
      fill_in 'Email', with: ""
      fill_in 'Password', with: ""
      # ログインボタンを押す
      find('input[name="commit"]').click
      # ログインページへ戻されることを確認する
      expect(current_path).to eq ('/users/sign_in')
    end
  end
end

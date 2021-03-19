require 'rails_helper'

RSpec.describe Tweet, type: :system do
  # letは、定義した定数が初めて使われたときに評価される。（遅延評価）
  # let!は、各テストのブロック実行前に定義した定数を作る。（事前評価）
  # 以下のlet!をletにするとテストがパスしない。
  # DBに登録する必要があるため「build」ではなく「create」とする。
  let!(:tweet) { create(:tweet) }

  describe 'List screen' do
    before do
      visit tweets_path
    end
    context '#index' do
      it 'displays content of the tweet' do
        expect(page).to have_content tweet.content
      end

      it 'displays a link to the details screen' do
        expect(page).to have_link 'Show', href: "/tweets/#{tweet.id}"
      end

      it 'displays a link to the editing screen' do
        expect(page).to have_link 'Edit', href: "/tweets/#{tweet.id}/edit"
      end

      it 'displays a link to delete a tweet' do
        expect(page).to have_link 'Destroy', href: "/tweets/#{tweet.id}"
      end

      it 'displays a link to post a tweet' do
        expect(page).to have_link 'New Tweet', href: "/tweets/new"
      end
    end

    context '#destroy' do
      it "decreases the number of tweet" do
        count = Tweet.count
        click_link 'Destroy'
        expect(Tweet.count).to eq (count - 1)
      end

      it "redirects to the list screen" do
        click_link 'Destroy'
        expect(current_path).to eq tweets_path
      end
    end
  end

  describe 'Post screen' do
    before do
      visit new_tweet_path
    end
    context '#new' do
      it "displays a form for content" do
        expect(page).to have_field 'tweet[content]'
      end

      it 'displays a Create Tweet Button' do
        expect(page).to have_button 'Create Tweet'
      end

      it 'displays a link to back to list screen' do
        expect(page).to have_link 'Back', href: "/tweets"
      end
    end

    context '#create' do
      it "returns a 200 OK status with a valid content" do
        fill_in 'tweet[content]', with: Faker::Lorem.characters(number: 100)
        click_button 'Create Tweet'
        expect(page).to have_http_status(200)
      end

      it "returns a 422 Unprocessable Entity status without content" do
        click_button 'Create Tweet'
        expect(page).to have_http_status(422)
      end

      it "returns a 422 Unprocessable Entity status with a content longer than 140" do
        fill_in 'tweet[content]', with: Faker::Lorem.characters(number: 141)
        click_button 'Create Tweet'
        expect(page).to have_http_status(422)
      end

      it "redirects to the details screen" do
        fill_in 'tweet[content]', with: Faker::Lorem.characters(number: 100)
        click_button 'Create Tweet'
        expect(current_path).to eq tweet_path(Tweet.last)
      end
    end
  end

  describe 'Details screen' do
    before do
      visit tweet_path(tweet)
    end
    context '#show' do
      it "displays content of the tweet" do
        expect(page).to have_content tweet.content
      end
      it "displays a link to the editing screen" do
        expect(page).to have_link 'Edit', href: "/tweets/#{tweet.id}/edit"
      end
      it "displays a link to back to list screen" do
        expect(page).to have_link 'Back', href: "/tweets"
      end
    end
  end

  describe 'Editing screen' do
    before do
      visit edit_tweet_path(tweet)
    end

    context '#edit' do
      it "displays the content in the form" do
        expect(page).to have_field 'tweet[content]', with: tweet.content
      end
    end

    context '#update' do
      it "returns a 200 OK status with a valid content" do
        fill_in 'tweet[content]', with: Faker::Lorem.characters(number: 120)
        click_button 'Update Tweet'
        expect(page).to have_http_status(200)
      end

      it "returns a 422 Unprocessable Entity status without content" do
        fill_in 'tweet[content]', with: ""
        click_button 'Update Tweet'
        expect(page).to have_http_status(422)
      end

      it "returns a 422 Unprocessable Entity status with a content longer than 140" do
        fill_in 'tweet[content]', with: Faker::Lorem.characters(number: 141)
        click_button 'Update Tweet'
        expect(page).to have_http_status(422)
      end

      it "redirects to the details screen" do
        fill_in 'tweet[content]', with: Faker::Lorem.characters(number: 100)
        click_button 'Update Tweet'
        expect(current_path).to eq tweet_path(Tweet.last)
      end
    end
  end
end
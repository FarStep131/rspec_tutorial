require 'rails_helper'

RSpec.describe Tweet, type: :system do
  let!(:tweet) { create(:tweet) }

  describe 'List screen' do
    before do
      visit tweets_path
    end
    describe '#index' do
      it 'displays content of the tweet' do
        expect(page).to have_content tweet.content
      end

      it 'displays a link to the details screen' do
        expect(page).to have_link 'Show this tweet', href: "/tweets/#{tweet.id}"
      end

      it 'displays a link to post a tweet' do
        expect(page).to have_link 'New tweet', href: "/tweets/new"
      end
    end
  end

  describe 'Post screen' do
    before do
      visit new_tweet_path
    end
    describe '#new' do
      it "displays a form for content" do
        expect(page).to have_field 'tweet[content]'
      end

      it 'displays a Create Tweet Button' do
        expect(page).to have_button 'Create Tweet'
      end

      it 'displays a link to back to list screen' do
        expect(page).to have_link 'Back to tweets', href: "/tweets"
      end
    end

    describe '#create' do
      it "redirects to the details screen with a valid content" do
        fill_in 'tweet[content]', with: Faker::Lorem.characters(number: 100)
        click_button 'Create Tweet'
        expect(current_path).to eq tweet_path(Tweet.last)
      end

      it "displays created tweet with a valid content" do
        fill_in 'tweet[content]', with: Faker::Lorem.characters(number: 100)
        click_button 'Create Tweet'
        expect(page).to have_content Tweet.last.content
      end

      it "displays message 'Content can't be blank' without content" do
        click_button 'Create Tweet'
        expect(page).to have_content "Content can't be blank"
      end

      it "returns a 422 Unprocessable Entity status without content" do
        click_button 'Create Tweet'
        expect(page).to have_http_status(422)
      end

      it "displays message 'Content is too long (maximum is 140 characters)' with a content longer than 140" do
        fill_in 'tweet[content]', with: Faker::Lorem.characters(number: 141)
        click_button 'Create Tweet'
        expect(page).to have_content "Content is too long (maximum is 140 characters)"
      end

      it "returns a 422 Unprocessable Entity status with a content longer than 140" do
        fill_in 'tweet[content]', with: Faker::Lorem.characters(number: 141)
        click_button 'Create Tweet'
        expect(page).to have_http_status(422)
      end
    end
  end

  describe 'Details screen' do
    before do
      visit tweet_path(tweet)
    end
    describe '#show' do
      it "displays content of the tweet" do
        expect(page).to have_content tweet.content
      end
      it "displays a link to the editing screen" do
        expect(page).to have_link 'Edit this tweet', href: "/tweets/#{tweet.id}/edit"
      end
      it "displays a link to back to list screen" do
        expect(page).to have_link 'Back to tweets', href: "/tweets"
      end
    end
    describe '#destroy' do
      it "decreases the number of tweet" do
        count = Tweet.count
        click_on 'Destroy this tweet'
        expect(Tweet.count).to eq (count - 1)
      end

      it "redirects to the list screen" do
        click_on 'Destroy this tweet'
        expect(current_path).to eq tweets_path
      end
    end
  end

  describe 'Editing screen' do
    before do
      visit edit_tweet_path(tweet)
    end

    describe '#edit' do
      it "displays the content in the form" do
        expect(page).to have_field 'tweet[content]', with: tweet.content
      end

      it 'displays a Update Tweet Button' do
        expect(page).to have_button 'Update Tweet'
      end

      it 'displays a link to the details screen' do
        expect(page).to have_link 'Show this tweet', href: "/tweets/#{tweet.id}"
      end

      it 'displays a link to back to list screen' do
        expect(page).to have_link 'Back to tweets', href: "/tweets"
      end
    end

    describe '#update' do
      it "redirects to the details screen with a valid content" do
        fill_in 'tweet[content]', with: Faker::Lorem.characters(number: 100)
        click_button 'Update Tweet'
        expect(current_path).to eq tweet_path(Tweet.last)
      end

      it "displays created tweet with a valid content" do
        fill_in 'tweet[content]', with: Faker::Lorem.characters(number: 100)
        click_button 'Update Tweet'
        expect(page).to have_content Tweet.last.content
      end

      it "displays message 'Content can't be blank' without content" do
        fill_in 'tweet[content]', with: ""
        click_button 'Update Tweet'
        expect(page).to have_content "Content can't be blank"
      end

      it "returns a 422 Unprocessable Entity status without content" do
        fill_in 'tweet[content]', with: ""
        click_button 'Update Tweet'
        expect(page).to have_http_status(422)
      end

      it "displays message 'Content is too long (maximum is 140 characters)' with a content longer than 140" do
        fill_in 'tweet[content]', with: Faker::Lorem.characters(number: 141)
        click_button 'Update Tweet'
        expect(page).to have_content "Content is too long (maximum is 140 characters)"
      end

      it "returns a 422 Unprocessable Entity status with a content longer than 140" do
        fill_in 'tweet[content]', with: Faker::Lorem.characters(number: 141)
        click_button 'Update Tweet'
        expect(page).to have_http_status(422)
      end
    end
  end
end

require 'rails_helper'

RSpec.describe "Pages", type: :system do
  describe '#home' do
    it 'renders the top page' do
      visit root_path
      expect(page.status_code).to eq(200)
    end
  end
end

require 'spec_helper'

describe "Quizzes" do
  before(:each) do
    stub_plus_discovery_document
    stub_current_user_profile
  end

  %w(/ /quizzes).each do |path|
    it 'should redirect you to login' do
      visit path
      page.current_url.should == 'http://www.example.com/oauth2authorize'
    end
  end

  describe 'index' do
    it 'shows a list of quizzes' do
      Factory :quiz
      login
      page.should have_content('Scrabble for Nihilists')
      page.should have_content('47')
      page.should have_content('United States')
    end

    it 'says something when there are no quizzes' do
      login
      page.should have_content('There are no quizzes yet')
    end

    it 'allows you to create a new quiz' do
      login
      click_link 'Create a new quiz'
      page.should have_content('New quiz')
    end
  end

  describe 'edit' do
    # Advanced validation is tested in models/quiz_spec.rb.
    it 'does validation' do
      login
      stub_plus_discovery_document
      stub_current_user_profile
      visit new_quiz_path
      click_button 'Create Quiz'
      ['Name', 'Country alpha2'].each do |field|
        page.should have_content("#{field} can't be blank")
      end
    end
  end

  describe 'show' do
    it 'has an edit link' do
      Factory :quiz
      login
      click_link 'Scrabble for Nihilists'
      click_link 'Edit'
    end

    it 'shows an embedded player' do
      Factory :quiz
      login
      click_link 'Scrabble for Nihilists'
      page.should have_css('iframe.player')
    end

    it 'tells you if there is no video' do
      Factory :quiz, :video_id => nil
      login
      click_link 'Scrabble for Nihilists'
      page.should have_content('This is no video associated with this quiz yet.')
    end
  end
end
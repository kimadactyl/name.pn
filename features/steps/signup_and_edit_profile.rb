class Spinach::Features::SignupAndEditProfile < Spinach::FeatureSteps
  include CommonSteps::Auth

  step 'I visit the sign up page' do
    visit new_user_registration_path
  end

  step 'I fill in my email address and a password' do
    fill_in 'Your email address', with: 'loglady@example.com'
    fill_in 'Password', with: 'th4tn1ght'
    fill_in 'Password confirmation', with: 'th4tn1ght'
  end

  step 'I submit the form' do
    click_button 'Submit'
  end

  step 'I should be on the first page of the profile editor' do
    expect(page).to have_css('.profile-form h1', text: 'Your name')
  end

  step 'my account should have been created on the backend' do
    expect(User.find_by email: 'loglady@example.com').to be_a User
  end

  step 'I fill in my personal name details' do
    fill_in 'Your "full" name', with: 'Log Lady'
    fill_in 'Your personal name', with: 'Margaret'
  end

  step 'I go to the next stage' do
    click_button 'Next step'
  end

  step 'I fill in my formal name details' do
    fill_in 'Your envelope name', with: 'Mrs M. Lanterman'
    fill_in 'Your formal name', with: 'Mrs Lanterman'
  end

  step 'I fill in my pronunciation' do
    fill_in 'Phonetic pronunciation of \'Log Lady\'', with: 'LOG LAY-dee'
    fill_in 'Advanced: IPA pronunciation', with: 'lɒg ˈleɪdi'
  end

  step 'I select my pronouns as she/her' do
    check 'she/her'
  end
  
  step 'I select the running example' do
    select 'Running', from: 'Pronoun example'
  end

  step 'I click to finish' do
    click_button 'Finish my profile'
  end

  step 'I should be on the dashboard' do
    expect(page).to have_css('h1', text: 'Your name dashboard')
  end

  step 'my profile should be completed successfully' do
    user = User.find_by(email: 'loglady@example.com')
    expect(user.personal_name).to eq('Margaret')
    expect(user.full_name).to eq('Log Lady')
    expect(user.formal_name).to eq('Mrs Lanterman')
    expect(user.envelope_name).to eq('Mrs M. Lanterman')
    expect(user.phonetic).to eq('LOG LAY-dee')
    expect(user.ipa).to eq('lɒg ˈleɪdi')
    expect(user).to be_pronoun_example_running
    expect(user.pronoun_sets.map(&:to_s)).to eq(['she/her'])
    expect(user.slug).to eq('log-lady')
    expect(user).not_to be_noindex
  end

  step 'an Audrey Horne profile already exists' do
    create :user, full_name: 'Audrey Horne'
  end

  step 'I fill in audrey-horne as a slug' do
    fill_in id: 'user_slug', with: 'audrey-horne'
  end

  step 'I should still be on the slug-editing page' do
    expect(page).to have_css('h1', text: 'Your URL')
  end

  step 'I should see a message telling me there was a conflict' do
    expect(page).to have_content('That URL is already in use. Here is a suggestion for an alternative!')
  end

  step 'I should see a suggested alternative name prefilled' do
    expect(page).to have_css('input[value="log-lady"]')
  end

  step 'I click to save and exit' do
    click_button 'Save and exit'
  end

  step 'my profile should be partially completed' do
    user = User.find_by(email: 'loglady@example.com')
    expect(user.personal_name).to eq('Margaret')
    expect(user.full_name).to eq('Log Lady')
    expect(user.formal_name).to eq('Mrs Lanterman')
    expect(user.envelope_name).to eq('Mrs M. Lanterman')
    expect(user.phonetic).to be nil
    expect(user.pronoun_sets).to be_empty
  end

  step 'I visit the dashboard' do
    visit '/'
  end

  step 'I click the edit button in the pronouns box' do
    within '.card.is-pronouns' do
      click_on 'Edit'
    end
  end

  step 'I should be on the pronouns page of the profile editor' do
    expect(page).to have_css('h1', text: 'Your pronouns')
  end
  
  step 'I click to add an image' do
    click_button 'Set image'
  end

  step 'I attach my likeness' do
    within '.uppy-Dashboard-AddFiles' do
      first('input[type="file"]', visible: false).set(file_fixture 'leeds.png')
    end
  end

  step 'I accept the defaults in the image editor' do
    expect(page).to have_css('.cropper-crop-box')
    # Check the cropping has been applied
    expect(find('.cropper-crop-box')['style']).to match /width: (.*?)px; height: \1px/
    within '.uppy-DashboardContent-panel' do
      click_button 'Save'
    end
  end

  step 'my likeness should be cropped' do
    user = User.find_by(email: 'loglady@example.com')
    expect(user.likeness).to be_attached
    blob = user.likeness.attachment.blob
    expect(blob.metadata['width']).to eq(blob.metadata['height'])
  end
  
  step 'I click twice to add a link' do
    click_link 'Add a link'
    expect(page).to have_css('label', text: 'Title', count: 1)
    click_link 'Add a link'
    expect(page).to have_css('label', text: 'Title', count: 2)
  end

  step 'I fill in my Twitter and LinkedIn details' do
    within all('.link-fields')[0] do
      fill_in 'Title', with: 'Twitter @LogLady'
      fill_in 'URL', with: 'https://twitter.com/LogLady'
    end
    within all('.link-fields')[1] do
      fill_in 'Title', with: 'LinkedIn @mlanterman'
      fill_in 'URL', with: 'https://www.linkedin.com/in/mlanterman'
    end
  end

  step 'both my links should be added' do
    user = User.find_by(email: 'loglady@example.com')
    expect(user.links.map(&:title).sort).to eq(['LinkedIn @mlanterman', 'Twitter @LogLady'])
  end
  
  step 'I click the edit button in the links box' do
    within '.card.is-links' do
      click_on 'Edit'
    end
  end

  step 'I click to delete the first link' do
    within all('.link-fields')[0] do
      click_link 'Remove'
    end
  end

  step 'my profile should only have one link attached' do
    user = User.find_by(email: 'testuser@example.com')
    expect(user.links.map(&:title).sort).to eq(['LinkedIn'])
  end
  
  step 'I click the edit button in the pronunciation box' do
    within '.card.is-pronunciation' do
      click_on 'Edit'
    end
  end

  step 'I select my personal name from the dropdown' do
    select 'Audrey', from: 'Which version of your name would you like to pronounce?'
  end

  step 'the hints on the page should update to my personal name' do
    expect(page).to have_content("Phonetic pronunciation of 'Audrey'")
    expect(page).to have_content("Record yourself saying 'Audrey'")
  end

  step 'I should see the correct form of my name in the pronunciation box on the dashboard' do
    expect(page).to have_content("Audrey is pronounced")
    expect(page).to have_content("Audio clip of 'Audrey'")
  end
  
  step 'I try to go the home page' do
    visit '/'
  end

  step 'I should be redirected back to the first page of the profile editor' do
    expect(page).to have_css('.box.profile-form.is-personal-name')
  end

  step 'I should not see links to the other sections' do
    expect(page).not_to have_css('a.steps-marker[href]')
  end

  step 'I should not see a save and exit button' do
    expect(page).not_to have_css('button', text: 'Save and exit')
  end

  step 'I have filled out my personal name and full name elsewhere' do
    test_user.update(full_name: 'Harold Smith', personal_name: 'Harold')
  end

  step 'I should see the dashboard' do
    expect(page).to have_css('.title', text: 'Your name dashboard')
  end

  step 'I go to the profile editor' do
    visit '/profile/personal_name'
  end

  step 'I should see links to the other sections' do
    expect(page).to have_css('a.steps-marker[href]')
  end

  step 'I should see a save and exit button' do
    expect(page).to have_css('button', text: 'Save and exit')
  end
  
  step 'I click twice to add alternate names' do
    click_link 'Add alternate name'
    expect(page).to have_css('label', text: 'Category', count: 1)
    click_link 'Add alternate name'
    expect(page).to have_css('label', text: 'Category', count: 2)
  end

  step 'I add a name I like and one I dislike' do
    within all('.alternate_name-fields')[0] do
      fill_in 'Name', with: 'Logs'
      select 'I like it', from: 'Category'
    end
    within all('.alternate_name-fields')[1] do
      fill_in 'Name', with: 'Mags'
      select 'I don\'t like it', from: 'Category'
    end
  end

  step 'both my alternate names should be added correctly' do
    user = User.find_by(email: 'loglady@example.com')
    expect(user.alternate_names.category_like.pluck(:name)).to eq(['Logs'])
    expect(user.alternate_names.category_dislike.pluck(:name)).to eq(['Mags'])
  end
  
  step 'I click the edit button in the variants box' do
    within '.card.is-variants' do
      click_on 'Edit'
    end
  end

  step 'I click to delete the first alternate name' do
    within all('.alternate_name-fields')[0] do
      click_link 'Remove'
    end
  end

  step 'my profile should only have two alternate names attached' do
    user = User.find_by(email: 'testuser@example.com')
    expect(user.alternate_names.map(&:name).sort).to eq(['Aud', 'Scarlett'])
  end
  
  step 'I click the edit button in the URL box' do
    within '.card.is-url' do
      click_on 'Edit', match: :first
    end
  end

  step 'I select the checkbox to hide from search engines' do
    check 'Hide from search engines?'
  end

  step 'my profile should be marked as noindex' do
    user = User.find_by(email: 'testuser@example.com')
    expect(user).to be_noindex
  end
  
  step 'I click the edit button in the likeness box' do
    within '.card.is-likeness' do
      click_on 'Edit', match: :first
    end
  end

  step 'I attach a likeness that is too large' do
    within '.uppy-Dashboard-AddFiles' do
      first('input[type="file"]', visible: false).set(file_fixture 'rostyslav-savchyn.jpg')
    end
  end

  step 'I should see an error that the file is too large' do
    expect(page).to have_content('rostyslav-savchyn.jpg exceeds maximum allowed size of 1 MB')
  end
end

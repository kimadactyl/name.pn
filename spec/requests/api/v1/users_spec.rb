require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  path '/api/v1/users/{slug}' do
    parameter name: 'slug', in: :path, type: :string, description: 'The slug of the user you want to retrieve', example: 'abby-yates'

    let!(:user) { create :user, :full_profile }

    get 'show user' do
      produces 'application/json'
      tags 'User profiles'
      needs_login
      
      let(:slug) { 'audrey-horne' }
                  
      response 200, 'successful' do        
        schema({
          '$ref': '#/components/schemas/User'
        })
        run_test! do
          expect(jr[:full_name]).to eq('Audrey Horne')
          expect(jr[:pronoun_sets][0][:nominative]).to eq('she')
          expect(jr[:links]).to have(2).items
          expect(jr[:pronunciation_of]).to eq('full_name')
          expect(jr[:likeness]).to end_with('likeness.png')
          expect(jr[:alternate_names]).to have(3).items
        end
      end
      
      response 404, 'not found' do
        let(:slug) { 'annie-blackburn' }
        run_test!
      end
    end
  end
end

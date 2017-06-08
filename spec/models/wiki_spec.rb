require 'rails_helper'

RSpec.describe Wiki, type: :model do
  let(:user) {User.create!(email: "blocipedia@bloc.com", password: "helloworld")}
  let(:wiki) {Wiki.create!(title: "New Wiki Title", body: "New Wiki Body", user: user)}

  describe "attributes" do
  	it "has title, body and user attributes" do
  	  expect(wiki).to have_attributes(title: "New Wiki Title", body: "New Wiki Body", user: user)
  	end
  end	  
end

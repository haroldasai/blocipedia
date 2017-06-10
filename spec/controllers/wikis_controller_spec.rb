require 'rails_helper'

RSpec.describe WikisController, type: :controller do

  let(:user) {User.create!(email: "blocipedia@bloc.com", password: "helloworld")}
  let(:admin_user) {User.create!(email: "admin@bloc.com", password: "helloworld", role: 2)}
  let(:my_wiki) {Wiki.create!(title: "New Wiki Title", body: "This is New Wiki Body Sentence.", user: user)}

  describe "GET index" do

    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end 
    
    it "assigns [my_wiki] to @wikis" do
      get :index
      expect(assigns(:wikis)).to eq([my_wiki])
    end

  end

  describe "GET new" do

    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end

    it "returns the #new view" do
      get :new
      expect(response).to render_template :new
    end  

    it "instantiates @wiki" do
      get :new
      expect(assigns(:wiki)).not_to be_nil
    end

  end

  describe "POST create" do

    before do
      user.confirm
      sign_in user
    end  

    it "sign user in and out" do
      get :index
      expect(controller.current_user).to eq(user)
    end 
 
    it "increses the number of Wiki by 1" do
      expect{post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}}.to change(Wiki,:count).by(1)
    end

    it "assigns the new wiki to @wiki" do
      post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
      expect(assigns(:wiki)).to eq Wiki.last
    end
    
    it "redirects to the new wiki" do
      post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
      expect(response).to redirect_to Wiki.last
    end 
  
  end

  describe "DELETE destroy" do
   
    before do
      Wiki.create!(title: "New Wiki Title", body: "This is New Wiki Body Sentence.", user: user)
    end

    it "reduces the number of Wiki by 1" do
      before = Wiki.count
      delete :destroy, {id: Wiki.last.id}
      expect(Wiki.count).to eq(before-1)
    end

    it "returns http redirect" do
      delete :destroy, {id: Wiki.last.id}
      expect(response).to redirect_to(wikis_path)
    end
  end

  describe "GET edit" do
    it "returns http success" do
      get :edit, {id: my_wiki.id}
      expect(response).to have_http_status(:success)
    end

    it "renders the #edit view" do
      get :edit, {id: my_wiki.id}
      expect(response).to render_template :edit
    end

    it "assigns wiki to be updated to @wiki" do
      get :edit, {id: my_wiki.id}
      wiki_instance = assigns(:wiki)

      expect(wiki_instance.id).to eq my_wiki.id
      expect(wiki_instance.title).to eq my_wiki.title
      expect(wiki_instance.body).to eq my_wiki.body
    end
  end

  describe "PUT update" do
    it "updates wiki with expected attributes" do
      new_title = RandomData.random_sentence
      new_body = RandomData.random_paragraph

      put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body}

      updated_wiki = assigns(:wiki)
      expect(updated_wiki.id).to eq my_wiki.id
      expect(updated_wiki.title).to eq new_title
      expect(updated_wiki.body).to eq new_body
    end

    it "redirects to the updated wiki" do
      new_title = RandomData.random_sentence
      new_body = RandomData.random_paragraph

      put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body}
      expect(response).to redirect_to my_wiki
    end
  end

  context "guest" do

    describe "Post create" do

      it "doesn't allow guest to create wiki" do
        before = Wiki.count
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect(Wiki.count).to eq(before)
      end
      
      it "redirects guest to new_user_registration_path" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect(response).to redirect_to new_user_registration_path
      end

    end

    describe "PUT update" do
      it "doesn't allow guests to updates wiki" do
        original_title = my_wiki.title
        original_body = my_wiki.body
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body}

        updated_wiki = Wiki.find(my_wiki.id)
        expect(updated_wiki.id).to eq my_wiki.id
        expect(updated_wiki.title).to eq original_title
        expect(updated_wiki.body).to eq original_body
      end

      it "redirects guest to the updated wiki" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body}
        expect(response).to redirect_to new_user_registration_path
      end
    end

    describe "DELETE destroy" do
      before do
        Wiki.create!(title: "New Wiki Title", body: "This is New Wiki Body Sentence.", user: user)
      end

      it "doesn't allow guest to delete wiki" do
        before = Wiki.count
        delete :destroy, {id: Wiki.last.id}
        expect(Wiki.count).to eq(before)
      end

      it "redirects guest to new_user_registration_path" do
        delete :destroy, {id: Wiki.last.id}
        expect(response).to redirect_to new_user_registration_path
      end
    end

  end

  context "free-user" do

    describe "Post create" do
      before do
        user.confirm
        sign_in user
      end

      it "allows free-user to create wiki" do
        before = Wiki.count
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect(Wiki.count).to eq(before+1)
      end

      it "redirects free-user to new_wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect(response).to redirect_to Wiki.last
      end
    end

    describe "PUT update" do
      before do
        user.confirm
        sign_in user
      end

      it "allows free-user to updates wiki" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body}

        updated_wiki = assigns(:wiki)
        expect(updated_wiki.id).to eq my_wiki.id
        expect(updated_wiki.title).to eq new_title
        expect(updated_wiki.body).to eq new_body
      end

      it "redirects free-user to the updated wiki" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body}
        expect(response).to redirect_to my_wiki
      end
    end

    describe "DELETE destroy" do
      before do
        Wiki.create!(title: "New Wiki Title", body: "This is New Wiki Body Sentence.", user: user)
        user.confirm
        sign_in user
      end

      it "doesn't allow free-user to delete wiki" do
        before = Wiki.count
        delete :destroy, {id: Wiki.last.id}
        expect(Wiki.count).to eq(before)
      end

    end

  end

  context "admin-user" do

    describe "Post create" do
      before do
        admin_user.confirm
        sign_in admin_user
      end

      it "allows admin-user to create wiki" do
        before = Wiki.count
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect(Wiki.count).to eq(before+1)
      end

      it "redirects admin-user to new_wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect(response).to redirect_to Wiki.last
      end
    end

    describe "PUT update" do
      before do
        admin_user.confirm
        sign_in admin_user
      end

      it "allows admin-user to updates wiki" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body}

        updated_wiki = assigns(:wiki)
        expect(updated_wiki.id).to eq my_wiki.id
        expect(updated_wiki.title).to eq new_title
        expect(updated_wiki.body).to eq new_body
      end

      it "redirects admin-user to the updated wiki" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body}
        expect(response).to redirect_to my_wiki
      end
    end

    describe "DELETE destroy" do
      before do
        Wiki.create!(title: "New Wiki Title", body: "This is New Wiki Body Sentence.", user: user)
        admin_user.confirm
        sign_in admin_user
      end

      it "allows admin-user to delete wiki" do
        before = Wiki.count
        delete :destroy, {id: Wiki.last.id}
        expect(Wiki.count).to eq(before-1)
      end
      
      it "redirects admin-user to wikis_path" do
        delete :destroy, {id: Wiki.last.id}
        expect(response).to redirect_to wikis_path
      end

    end

  end

end

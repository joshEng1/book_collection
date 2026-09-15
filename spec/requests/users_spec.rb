require "rails_helper"

RSpec.describe "Users", type: :request do
  it "creates, lists, shows, updates, and deletes a user" do
    get new_user_path
    expect(response).to have_http_status(:ok)
    expect do
      post users_path,
        params: { user: { username: "reader_one" } }
    end.to change(User,
      :count).by(1)
    user = User.last
    get users_path
    expect(response.body).to include("reader_one")
    get user_path(user)
    expect(response.body).to include("reader_one")
    get edit_user_path(user)
    expect(response).to have_http_status(:ok)
    patch user_path(user),
      params: { user: { username: "reader_two" } }
    expect(user.reload.username).to eq("reader_two")
    expect { delete user_path(user) }.to change(User, :count).by(-1)
  end

  it "rejects blank usernames on create and update" do
    expect do
      post users_path,
        params: { user: { username: " " } }
    end.not_to change(User, :count)
    expect(response).to have_http_status(:unprocessable_content)
    user = User.create!(username: "reader_one")
    patch user_path(user), params: { user: { username: " " } }
    expect(response).to have_http_status(:unprocessable_content)
    expect(user.reload.username).to eq("reader_one")
  end
end

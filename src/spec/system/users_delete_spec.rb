require 'rails_helper'

RSpec.describe "UsersDelete", type: :system do
  include TestHelper

  before do
    @user = create(:user)
  end

  describe "アカウント閉鎖のテスト" do
    it "閉鎖成功" do
      log_in_as_system(@user)
      visit "#{user_path(@user)}/delete_user"
      click_link "閉鎖する"
      page.driver.browser.switch_to.alert.accept
      expect(current_path).to eq root_path
      expect(page).to have_selector '.alert-success'
    end

    it "フレンドリーフォロワーディング" do
      visit "#{user_path(@user)}/delete_user"
      expect(current_path).to eq login_path
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq "#{user_path(@user)}/delete_user"
      click_link "閉鎖する"
      page.driver.browser.switch_to.alert.accept
      expect(current_path).to eq root_path
      expect(page).to have_selector '.alert-success'
    end
  end
end

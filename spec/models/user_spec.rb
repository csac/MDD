# encoding: utf-8
require 'spec_helper'

describe User do
  describe 'validations' do
    describe 'roles' do
      let (:user)   { Fabricate.build(:user) }
      let (:author) { Fabricate.build(:author) }

      it 'should not validate without a role' do
        user.roles_mask = nil
        user.should_not be_valid
        user.should have(1).errors_on(:roles)
      end

      it 'should validate with at least 1 role' do
        author.should be_valid
      end
    end

    describe 'email' do
      let (:user)   { Fabricate.build(:author, email: '') }

      it 'should not validate without an email' do
        user.should_not be_valid
        user.should have_at_least(1).errors_on(:email)
      end

      it 'should not validate without a valid email' do
        user.email = 'not_valid'
        user.should_not be_valid
        user.should have_at_least(1).errors_on(:email)
      end

      it 'should validate with a valid email' do
        user.email = 'valid@email.org'
        user.should be_valid
      end
    end

  end

  describe 'acl' do
    let(:visitor_ability) { Ability.new(nil) }
    let(:author) { Fabricate :author }
    let(:admin) { Fabricate :administrator }
    let(:author_ability) {
      Ability.new(author)
    }
    let(:admin_ability) {
      Ability.new(admin)
    }

    describe 'a visitor' do

      describe 'should not be able to' do

        it "manage users" do
          visitor_ability.should_not be_able_to(:manage, User)
        end

      end

    end

    describe 'a author' do

      describe 'should not be able to' do

        it "manage users" do
          author_ability.should_not be_able_to(:manage, User)
        end

        it 'read other users account' do
          author_ability.should_not be_able_to(:read, Fabricate(:author))
        end

        it 'edit other users account' do
          author_ability.should_not be_able_to(:update, Fabricate(:author))
        end

        it 'show other users account' do
          author_ability.should_not be_able_to(:show, Fabricate(:author))
        end

        it 'edit other users password' do
          author_ability.
            should_not be_able_to(:edit_password, Fabricate(:author))
        end

        it 'update other users password' do
          author_ability.
            should_not be_able_to(:update_password, Fabricate(:author))
        end
      end

      describe 'should be able to' do

        it 'edit his account' do
          author_ability.should be_able_to(:update, author)
        end

        it 'show his account' do
          author_ability.should be_able_to(:show, author)
        end

        it 'edit his password' do
          author_ability.should be_able_to(:edit_password, author)
        end

        it 'update his password' do
          author_ability.should be_able_to(:update_password, author)
        end

      end

    end

    describe 'an admin' do

      describe 'should be able to' do

        it "manage users" do
          admin_ability.should be_able_to(:manage, User)
        end

        it 'edit his password' do
          admin_ability.should be_able_to(:edit_password, admin)
        end

        it 'update his password' do
          admin_ability.should be_able_to(:update_password, admin)
        end

      end

    end

  end

end

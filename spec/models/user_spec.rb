require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { User.new(email: email, password: password) }

    let(:email) { 'test@example.com' }
    let(:password) { 'password123' }

    context 'with valid attributes' do
      it 'is valid with a unique email and valid password' do
        expect(subject).to be_valid
      end
    end

    context 'with invalid email' do
      let(:email) { 'invalid-email' }

      it 'is not valid without a proper email format' do
        expect(subject).not_to be_valid
        expect(subject.errors[:email]).to include("is invalid")
      end
    end

    context 'with missing email' do
      let(:email) { nil }

      it 'is not valid without an email' do
        expect(subject).not_to be_valid
        expect(subject.errors[:email]).to include("can't be blank")
      end
    end

    context 'with duplicate email' do
      before { User.create(email: email, password: password) }

      it 'is not valid with a duplicate email' do
        expect(subject).not_to be_valid
        expect(subject.errors[:email]).to include("has already been taken")
      end
    end

    context 'with short password' do
      let(:password) { 'short' }

      it 'is not valid with a password shorter than 8 characters' do
        expect(subject).not_to be_valid
        expect(subject.errors[:password]).to include("is too short (minimum is 8 characters)")
      end
    end

    context 'with long password' do
      let(:password) { 'a' * 16 }

      it 'is not valid with a password longer than 15 characters' do
        expect(subject).not_to be_valid
        expect(subject.errors[:password]).to include("is too long (maximum is 15 characters)")
      end
    end
  end
end

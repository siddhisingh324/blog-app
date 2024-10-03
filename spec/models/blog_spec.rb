require 'rails_helper'

RSpec.describe Blog, type: :model do
  describe 'validations' do
    subject { Blog.new(title: title, user: user) }

    let(:title) { 'Unique Blog Title' }
    let(:user) { User.create(email: 'user@example.com', password: 'password123') }

    context 'with valid attributes' do
      it 'is valid with a unique title and a user' do
        expect(subject).to be_valid
      end
    end

    context 'with missing title' do
      let(:title) { nil }

      it 'is not valid without a title' do
        expect(subject).not_to be_valid
        expect(subject.errors[:title]).to include("can't be blank")
      end
    end

    context 'with duplicate title' do
      before { Blog.create(title: title, user: user) }

      it 'is not valid with a duplicate title' do
        expect(subject).not_to be_valid
        expect(subject.errors[:title]).to include("has already been taken")
      end
    end

    context 'without a user' do
      let(:user) { nil }

      it 'is not valid without a user' do
        expect(subject).not_to be_valid
        expect(subject.errors[:user]).to include("must exist")
      end
    end
  end
end

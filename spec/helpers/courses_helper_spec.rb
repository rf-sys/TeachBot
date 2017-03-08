require 'rails_helper'

RSpec.describe CoursesHelper, type: :helper do
  describe '#access_to_course?' do
    describe 'accepts access (true) if the course...' do
      it 'is public and published' do
        course = create(:course)
        expect(access_to_course?(course, course.author)).to eq(true)
      end

      it 'is not public, auth user is no author' do
        course = create(:private_course)
        expect(access_to_course?(course, course.author)).to eq(true)
      end

      it 'it not public, published, auth user is no author but participant' do
        course = create(:private_course)
        user = create(:second_user)
        course.participants << user
        auth_as(user)
        expect(access_to_course?(course, user)).to eq(true)
      end


      it 'unpublished, auth user is author' do
        course = create(:unpublished_course)
        expect(access_to_course?(course, course.author)).to eq(true)
      end
    end

    describe 'denies access (false) if the course...' do
      it 'is not public, auth user is neither author nor participant' do
        course = create(:private_course)
        auth_user = auth_as(create(:second_user))
        expect(access_to_course?(course, auth_user)).to eq(false)
      end

      it 'is neither public nor published, auth user is no author but participant' do
        course = create(:private_course, published: false)
        user = create(:second_user)
        course.participants << user
        auth_as(user)
        expect(access_to_course?(course, user)).to eq(false)
      end

      it 'is neither public nor published, auth user is no author' do
        course = create(:unpublished_course)
        auth_user = auth_as(create(:second_user))
        expect(access_to_course?(course, auth_user)).to eq(false)
      end
    end
  end
end
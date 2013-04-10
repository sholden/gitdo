require 'spec_helper'

describe 'Todo' do
  let(:user) { 'sholden' }
  let(:comment) { 'comment' }
  let(:updated_at) { Time.now }

  subject { Gitdo::Todo.new(user, comment, updated_at)}

  its(:user) { should == user }
  its(:comment) { should == comment }
  its(:updated_at) { should == updated_at }
end
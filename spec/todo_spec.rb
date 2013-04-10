require 'spec_helper'

describe 'Todo' do
  let(:comment) { 'comment' }
  let(:file) { 'file' }
  let(:line) { 1 }
  let(:author) { 'author' }
  let(:email) { 'email' }
  let(:created_at) { Time.now }

  subject { Gitdo::Todo.new(comment, file, line, author, email, created_at)}

  its(:comment) { should == comment }
  its(:file) { should == file }
  its(:line) { should == line }
  its(:author) { should == author }
  its(:email) { should == email }
  its(:created_at) { should == created_at }
end
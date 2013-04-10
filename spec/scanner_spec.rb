require 'spec_helper'

describe 'Scanner' do
  let(:path) { File.expand_path('../../', __FILE__) }

  subject { Gitdo::Scanner.new(path) }

  its(:tree) { should == 'master' }

  context 'with tree specified' do
    subject { Gitdo::Scanner.new(path, tree: 'branch') }
    its(:tree) { should == 'branch' }
  end

  it 'initializes with a path' do
    __FILE__.should == subject.path + '/spec/scanner_spec.rb'
  end

  its(:author) { should be_nil }

  context 'with author specified' do
    subject { Gitdo::Scanner.new(path, author: 'Scott Holden') }
    its(:author) { should == 'Scott Holden' }
  end

  its(:email) { should be_nil }

  context 'with email specified' do
    subject { Gitdo::Scanner.new(path, email: 'scott@sshconnection.com') }
    its(:email) { should == 'scott@sshconnection.com' }
  end

  its(:blobs) { should_not be_empty }

  it 'finds example.rb' do
    subject.blobs.find{|b| b[:path] == 'spec/fixtures/example.rb' }.should_not be_nil
  end

  it 'creates a blame for example.rb' do
    blame = subject.blame('spec/fixtures/example.rb')
    blame.lines.should_not be_empty
  end

  it 'finds a todo from scott@sshconnection' do
    subject.todos.should have(1).todo
    subject.todos.first.email.should == 'scott@sshconnection.com'
    subject.todos.first.line.should == 3
  end
end
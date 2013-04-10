require 'spec_helper'

describe 'Scanner' do
  let(:path) { File.expand_path('../fixtures', __FILE__) }

  subject { Gitdo::Scanner.new(path) }

  it 'initializes with a path' do
    subject.path.should match(/.+\/spec\/fixtures$/)
  end

  it 'finds todos in a file' do

  end
end
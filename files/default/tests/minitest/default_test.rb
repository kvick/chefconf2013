require File.expand_path('../support/helpers', __FILE__)

describe 'myface::default' do

  include Helpers::Myface

  # Example spec tests can be found at http://git.io/Fahwsw
  # it 'runs no tests by default' do
  #end

  # Check if a user has been created
  it "creates a service account for the myface daemon" do
    user("myface").must_exist
  end
end
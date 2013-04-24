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

  # Verify that MySQL is started and enabled
  it "Enables and starts the mysql daemon" do
    service("mysqld").must_be_running
    service("mysqld").must_be_enabled
  end

  # Verify that the myface database has a user table
  it "Seeds the myface database" do
    myface_tables.must_include "users"
  end
end
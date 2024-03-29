module Helpers
  module Myface
    include MiniTest::Chef::Assertions
    include MiniTest::Chef::Context
    include MiniTest::Chef::Resources

    # This function returns an array of all tables in the myface database
    def myface_tables
        require 'mysql'
        connection = ::Mysql.new 'localhost', 'root', node['mysql']['server_root_password']
        mfts = connection.select_db('myface').list_tables
    end
  end

end

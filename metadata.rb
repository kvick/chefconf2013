name             "myface"
maintainer       "K. Vick"
maintainer_email "kvick@netflix.com"
license          "All rights reserved"
description      "Installs/Configures myface"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.3.0"

depends "mysql", "= 2.1.2"
depends "database", "= 1.3.12"

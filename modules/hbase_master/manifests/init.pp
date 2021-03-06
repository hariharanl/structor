#  Licensed to the Apache Software Foundation (ASF) under one or more
#   contributor license agreements.  See the NOTICE file distributed with
#   this work for additional information regarding copyright ownership.
#   The ASF licenses this file to You under the Apache License, Version 2.0
#   (the "License"); you may not use this file except in compliance with
#   the License.  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

class hbase_master {
  require hbase_server

  $path="/usr/bin"

  package { "hbase${package_version}-master" :
    ensure => installed,
  }
  ->
  exec { "hdp-select set hbase-master ${hdp_version}":
    cwd => "/",
    path => "$path",
  }
  ->
  file { "/etc/init.d/hbase-master":
    ensure => file,
    source => "puppet:///files/init.d/hbase-master",
    owner => root,
    group => root,
    mode => '755',
    # TODO when we move to 2.5 grab Carter's change to use script from package
  }
  ->
  service {"hbase-master":
    ensure => running,
    enable => true,
    subscribe => File['/etc/hbase/conf/hbase-site.xml'],
  }
}

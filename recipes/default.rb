#
# Cookbook Name:: cartodb_github
# Recipe:: default
#
# Copyright 2012, WCMC
#
# All rights reserved - Do Not Redistribute
#
bash "Install RVM and Ruby" do
user "ubuntu"
group "ubuntu"
code <<-EOF
mkdir /home/ubuntu/downloads
cd /home/ubuntu/downloads
bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )
echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function' >> ~/.bash_profile
source ~/.bash_profile
rvm install 1.9.2
rvm use 1.9.2
rvm use 1.9.2 --default
EOF
end
execute "Install CartoDB and dependencies " do
user "ubuntu"
group "ubuntu"
command <<-EOH
sudo apt-get update
sudo apt-get install -y build-essential libxslt-dev
mkdir /home/ubuntu/downloads 
cd /home/ubuntu/downloads 
sudo apt-get install -y git-core libssl-dev 
git clone https://github.com/joyent/node.git 
cd /home/ubuntu/downloads/node
git checkout v0.4.9 
./configure 
make 
sudo make install 
curl http://npmjs.org/install.sh | sudo sh
sudo curl http://npmjs.org/install.sh | sudo sh
sudo add-apt-repository ppa:pitti/postgresql
sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
sudo add-apt-repository ppa:juan457/zorba
sudo apt-get update
sudo apt-get install -y libgdal-dev libgeos-dev libproj-dev postgresql-9.1 postgresql-server-dev-9.1 postgresql-contrib-9.1 gdal-bin postgresql-plpython-9.1
sudo apt-get install -y subversion autoconf
cd /home/ubuntu/downloads
svn checkout http://svn.osgeo.org/postgis/trunk@8242 postgis
cd /home/ubuntu/downloads/postgis
./autogen.sh
./configure
make
sudo make install
cd /home/ubuntu/downloads
wget http://redis.googlecode.com/files/redis-2.4.6.tar.gz
tar xzf redis-2.4*
cd /home/ubuntu/downloads/redis-2.4*
make
sudo make install
cd /home/ubuntu/downloads
git clone https://github.com/Vizzuality/cartodb.git
cd /home/ubuntu/downloads/cartodb
sudo apt-get install -y python-setuptools
sudo easy_install pip
sudo pip install -r /home/ubuntu/downloads/cartodb/python_requirements.txt
sudo pip install -e git+https://github.com/RealGeeks/python-varnish.git@0971d6024fbb2614350853a5e0f8736ba3fb1f0d#egg=python-varnish
sudo apt-get install -y g++ cpp python-dev libxml2 libxml2-dev libfreetype6 libfreetype6-dev libjpeg62 libjpeg62-dev libltdl7 libltdl-dev libpng12-0 libpng12-dev libgeotiff-dev libtiff4 libtiff4-dev libtiffxx0c2 libcairo2 libcairo2-dev python-cairo python-cairo-dev libcairomm-1.0-1 libcairomm-1.0-dev ttf-unifont ttf-dejavu ttf-dejavu-core ttf-dejavu-extra subversion build-essential python-nose libgdal1-dev python-gdal libsqlite3-dev
cd /home/ubuntu/downloads
wget http://download.icu-project.org/files/icu4c/4.6/icu4c-4_6-src.tgz
tar xzvf icu4c-4_6-src.tgz
cd /home/ubuntu/downloads/icu*/source
./runConfigureICU Linux
make
sudo make install
sudo ldconfig
wget http://voxel.dl.sourceforge.net/project/boost/boost/1.46.1/boost_1_46_1.tar.bz2
tar xjvf boost_1*
cd boost*
./bootstrap.sh
./bjam --with-thread --with-filesystem --with-python --with-regex -sHAVE_ICU=1 -sICU_PATH=/usr/local  --with-program_options --with-system link=shared toolset=gcc stage
sudo ./bjam --with-thread --with-filesystem --with-python --with-regex -sHAVE_ICU=1 -sICU_PATH=/usr/local --with-program_options --with-system toolset=gcc link=shared install
sudo ldconfig
cd /home/ubuntu/downloads
wget https://github.com/downloads/mapnik/mapnik/mapnik-2.0.0.tar.bz2
tar xjvf mapnik-2.0.0.tar.bz2
cd /home/ubuntu/downloads/mapnik-2.0.0
./configure
sudo python scons/scons.py install
cd /home/ubuntu/downloads
git clone git://github.com/Vizzuality/CartoDB-SQL-API.git
cd CartoDB-SQL-API
npm install
cd /home/ubuntu/downloads
git clone git://github.com/Vizzuality/Windshaft-cartodb.git
cd Windshaft-cartodb
npm install
sudo pg_dropcluster --stop 9.1 main
sudo pg_createcluster --start -e UTF-8 9.1 main
POSTGIS_SQL_PATH='pg_config --sharedir'/contrib/postgis-2.0
sudo -u postgres createdb -E UTF8 template_postgis
sudo -u postgres createlang -d template_postgis plpgsql
sudo -u postgres psql -d postgres -c "UPDATE pg_database SET datistemplate='true' WHERE datname='template_postgis';"
sudo -u postgres psql -d template_postgis -f /usr/share/postgresql/9.1/contrib/postgis-2.0/postgis.sql
sudo -u postgres psql -d template_postgis -f /usr/share/postgresql/9.1/contrib/postgis-2.0/spatial_ref_sys.sql
sudo -u postgres psql -d template_postgis -f /usr/share/postgresql/9.1/contrib/postgis-2.0/legacy.sql
sudo -u postgres psql -d template_postgis -f /usr/share/postgresql/9.1/contrib/postgis-2.0/legacy_compatibility_layer.sql
sudo -u postgres psql -d template_postgis -c "GRANT ALL ON geometry_columns TO PUBLIC;"
sudo -u postgres psql -d template_postgis -c "GRANT ALL ON spatial_ref_sys TO PUBLIC;"
mv ~/.rvm/usr/lib ~/.rvm/usr/lib_rvm
rvm rvmrc trust "/home/ubuntu/downloads/cartodb/.rvmrc"
cd /home/ubuntu/downloads/cartodb/
rvm use 1.9.2@cartodb --create
/home/ubuntu/.rvm/gems/ruby-1.9.2-p290@global/bin/bundle install --binstubs
cp /home/ubuntu/downloads/cartodb/config/app_config.yml.sample /home/ubuntu/downloads/cartodb/config/app_config.yml
cp /home/ubuntu/downloads/cartodb/config/database.yml.sample /home/ubuntu/downloads/cartodb/config/database.yml
sed -i 's,some_secret,a0be302d0c2b616096974fdf0409a619,g' /home/ubuntu/downloads/cartodb/config/app_config.yml
sudo ln -s  /usr/lib/postgresql/9.1/bin/shp2pgsql /usr/bin
sudo rm /etc/postgresql/9.1/main/pg_hba.conf
sudo touch /etc/postgresql/9.1/main/pg_hba.conf
sudo sh -c "echo 'local   all             postgres                                trust' >> /etc/postgresql/9.1/main/pg_hba.conf "
sudo sh -c "echo 'local   all             all                                     trust' >> /etc/postgresql/9.1/main/pg_hba.conf "
sudo sh -c "echo 'host    all             all             127.0.0.1/32            trust' >> /etc/postgresql/9.1/main/pg_hba.conf "
sudo sh -c "echo 'host    all             all             ::1/128                 trust' >> /etc/postgresql/9.1/main/pg_hba.conf "
sudo chown postgres:postgres /etc/postgresql/9.1/main/pg_hba.conf
sudo /etc/init.d/postgresql restart
redis-server >> /dev/null 2>&1 &
cd /home/ubuntu/downloads/Windshaft-cartodb
node app.js development >> /dev/null 2>&1  &
cd /home/ubuntu/downloads/CartoDB-SQL-API
node app.js development >> /dev/null 2>&1  &
cd /home/ubuntu/downloads/cartodb
rails s -d
bundle exec rake cartodb:db:setup EMAIL=username@mysubdomain.com SUBDOMAIN=mysubdomain PASSWORD=password ADMIN_PASSWORD=password
sudo apt-get update
sudo apt-get install -y build-essential libopenssl-ruby libcurl4-openssl-dev libssl-dev zlib1g-dev
sudo sh -c "echo '127.0.0.1 admin.localhost.lan admin.testhost.lan' >> /etc/hosts"
sudo sh -c "echo '127.0.0.1 my_subdomain.localhost.lan' >> /etc/hosts"
cd /home/ubuntu/downloads
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.21.tar.gz
tar xvf pcre-8.21.tar.gz
cd pcre-8.21
./configure
make
sudo make install
sudo apt-get update
sudo apt-get install -y build-essential libopenssl-ruby libcurl4-openssl-dev libssl-dev zlib1g-dev
cd /home/ubuntu/downloads/cartodb/public
gem install passenger
rvmsudo passenger-install-nginx-module --auto --prefix=/usr/local/nginx --auto-download
sudo ldconfig
EOH
end
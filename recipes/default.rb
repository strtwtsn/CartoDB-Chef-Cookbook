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
cd /home/ubuntu/downloads
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.21.tar.gz
tar xvf pcre-8.21.tar.gz
cd pcre-8.21
./configure
make
sudo make install
sudo apt-get update
sudo apt-get install -y build-essential libopenssl-ruby libcurl4-openssl-dev libssl-dev zlib1g-dev
/home/ubuntu/downloads/cartodb/public
gem install passenger
rvmsudo passenger-install-nginx-module --auto --prefix=/usr/local/nginx --auto-download
sudo ldconfig
# Things that need to be installed on Ubuntu 16.04 to get osrm to work

# From the official documentation (for compiling OSRM)
sudo apt-get install -y \
  build-essential \
  cmake \
  git \
  libbz2-dev \
  libboost-all-dev \
  liblua5.1-0-dev \
  libluabind-dev \
  libstxxl-dev \
  libstxxl1v5 \
  libtbb-dev \
  libxml2-dev \
  libzip-dev \
  lua5.1 \
  pkg-config

# To convert the DEM (elevation) files (and extract them as zips)
sudo apt-get install -y \
  gdal-bin \
  unzip

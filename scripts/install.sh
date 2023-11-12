#!/bin/bash

# usage: addenv env_name path
function addenv() {
  sed -i -e "/^export $1=.*/d" ~/.bashrc
  echo "export $1=`readlink -e $2`" >> ~/.bashrc
  echo "By default this script will add environment variables into ~/.bashrc."
  echo "After that, please run 'source ~/.bashrc' to let these variables take effect."
  echo "If you use shell other than bash, please add these environment variables manually."
}

# usage: init repo branch directory trace [env]
# trace = true|false
function init() {
  if [ -d ${PREFIX}/$3 ]; then
    echo "$3 is already initialized, skipping..."
    return
  fi

  while [ ! -d ${PREFIX}/$3 ]; do
    git clone -b $2 git@github.com:$1.git ${PREFIX}/$3
  done

  rm -rf ${PREFIX}/$3/.git

  if [ $5 ] ; then
    addenv $5 ${PREFIX}/$3
  fi
}

function install_verilator() {
  which verilator

  if [ $? -eq 0 ]; then
    echo 'Verilator has been installed, skipping...'
    return 0
  fi

  echo '### PREREQUEST INSTALL ###'
  sudo apt-get install git help2man perl python3 make autoconf g++ flex bison ccache
  sudo apt-get install libgoogle-perftools-dev numactl perl-doc
  echo 'Please ignore errors if the following packages fail installing.'
  sudo apt-get install libfl2
  sudo apt-get install libfl-dev
  sudo apt-get install zlibc zlib1g zlib1g-dev

  echo '### DOWNLOADING VERILATOR ###'
  git clone git@github.com:verilator/verilator ${PREFIX}/verilator
  cd ${PREFIX}/verilator
  
  # sanity check
  if [ ! -f src/VlcMain.cpp ]; then
    echo 'Unknown error: confusing directory structure in verilator repo,'
    echo "please check ${PREFIX}/verilator manually."
    exit 1
  fi

  unset VERILATOR_ROOT
  export VERILATOR_ROOT=${PREFIX}/verilator
  git checkout stable

  autoconf
  ./configure
  make -j `nproc`
  sudo make install

  if [ $? -ne 0 ]; then
    echo 'Installation failed, exiting...'
    exit 1
  fi

  addenv VERILATOR_ROOT ${PREFIX}/verilator
}

function install_tools() {
  echo '### Installing GTKWave ###'
  sudo apt-get install gtkwave
}

if [ -z ${PREFIX} ]; then
  echo '$PREFIX not set, exiting...'
fi

mkdir -p ${PREFIX}

if [ $? -ne 0 ]; then
  echo 'mkdir failed, exiting...'
fi

case $1 in
  nvboard)
    echo '### Installing NVBoard ###'
    init NJU-ProjectN/nvboard master nvboard false NVBOARD_HOME
    ;;
  verilator)
    install_verilator
    install_tools
    ;;
  *)
    echo "Invalid input..."
    exit
    ;;
esac

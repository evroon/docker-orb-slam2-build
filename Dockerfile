FROM dkimg/opencv:4.5.0-ubuntu
MAINTAINER Proud Heng <proud.heng@gmail.com>

# To build ORB_SLAM2 using this Docker image:
# docker run -v ~/docker/ORB_SLAM2/:/ORB_SLAM2/ -w=/ORB_SLAM2/ slam-test /bin/bash -c ./build.sh

ENV EIGEN_VERSION 3.3.2
ENV EIGEN_DOWNLOAD_URL https://gitlab.com/libeigen/eigen/-/archive/$EIGEN_VERSION/eigen-$EIGEN_VERSION.tar.gz

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  build-essential \
  cmake \
  curl \ 
  gcc \
  git \
  libglew-dev \
  libgtk2.0-dev \
  pkg-config \
  libavcodec-dev \
  libavformat-dev \
  libswscale-dev \
  python-dev \
  python-numpy \
  unzip 

# install Eigen
RUN curl -fsSL "$EIGEN_DOWNLOAD_URL" -o eigen.tar.gz \
  && mkdir /usr/include/eigen \
  # rename first directory to be eigen instead of eigen-eigen-*
  && tar -xf eigen.tar.gz --strip-components=1 -C /usr/include/eigen \
  && rm eigen.tar.gz

# install Pangolin
RUN git clone https://github.com/stevenlovegrove/Pangolin.git \
  && cd Pangolin \
  && mkdir build \
  && cd build \
  && cmake .. \
  && make

# build ORB-SLAM2
RUN git clone https://github.com/Windfisch/ORB_SLAM2 ORB_SLAM2 \
  && cd ORB_SLAM2 \
  && chmod +x build.sh

VOLUME ["/ORB_SLAM2/"]

CMD ["/bin/bash -c ./build.sh"]

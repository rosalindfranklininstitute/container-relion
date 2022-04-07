# Copyright 2022 Rosalind Franklin Institute
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
# either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

FROM nvidia/cuda:11.5.1-devel-ubuntu20.04 as build

# Update LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/cuda/lib64:/usr/local/cuda/compat/"

# Install packages and register python3 as python
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update -y && apt-get install --no-install-recommends -y dialog apt-utils && \
    apt-get install --no-install-recommends -y cmake git build-essential wget \
                                               mpi-default-bin mpi-default-dev libfftw3-dev libtiff-dev \
                                               libfontconfig1-dev libglu1-mesa-dev libice-dev libtool \
                                               libx11-dev libxcursor-dev libxext-dev libxft-dev libxi-dev \
                                               libxinerama-dev libxrender-dev && \
    apt-get autoremove -y --purge && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install relion
WORKDIR /tmp/relion
RUN git clone --branch 3.1.3 --depth 1 https://github.com/3dem/relion.git .
WORKDIR /tmp/relion/build
RUN cmake -DCMAKE_INSTALL_PREFIX=/usr/local/relion/ .. && \
    make -j 4 && \
    make install && \
    rm -rf /tmp/relion
ENV PATH="${PATH}:/usr/local/relion/bin"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/relion/lib"
WORKDIR /

FROM nvidia/cuda:11.5.1-runtime-ubuntu20.04

# Update LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/cuda/lib64:/usr/local/cuda/compat/"

# Install packages and register python3 as python
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update -y && apt-get install --no-install-recommends -y dialog apt-utils && \
    apt-get install --no-install-recommends -y mpi-default-bin libfftw3 libtiff \
                                               libfontconfig1 libglu1-mesa libice libtool \
                                               libx11 libxcursor libxext libxft libxi \
                                               libxinerama libxrender && \
    apt-get autoremove -y --purge && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Copy compiled relion from the build image
COPY --from=build /usr/local/relion /usr/local/
ENV PATH="${PATH}:/usr/local/relion/bin"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/relion/lib"

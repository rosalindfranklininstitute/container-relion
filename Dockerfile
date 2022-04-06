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

FROM nvidia/cuda:11.5.1-cudnn8-devel-ubuntu20.04

# Update LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/cuda/lib64:/usr/local/cuda/compat/"

# Install packages and register python3 as python
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update -y && apt-get install --no-install-recommends -y dialog apt-utils && \
    apt-get install --no-install-recommends -y cmake git build-essential wget \
                                               python cython3 python3 python3-dev python3-pip \
                                               mpi-default-bin mpi-default-dev libfftw3-dev libtiff-dev  && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 10 && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10 && \
    apt-get autoremove -y --purge && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install relion
WORKDIR /tmp/relion
RUN git clone --branch 3.1.3 --depth 1 https://github.com/3dem/relion.git .
WORKDIR /tmp/relion/build
RUN cmake -DCMAKE_INSTALL_PREFIX=/usr/local/relion/ ..
RUN make -j 4
RUN make install
RUN rm -rf /tmp/relion
ENV PATH="${PATH}:/usr/local/relion/bin"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/relion/lib"
WORKDIR /

FROM nvcr.io/nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04
# docker build -t dai:latest -f ./Dockerfile ./
# docker run --rm -it --gpus all -v $(pwd):/workspace dai:latest bash
WORKDIR /workspace
# Set en_US.UTF-8 locale by default
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment

# Install packages
RUN apt-get update && apt-get install -y --no-install-recommends --force-yes \
  build-essential \
  curl \
  wget \
  git \
  vim \
  iptables \
  iproute2 \
  iputils-ping \
  libgl1-mesa-glx \
  libglib2.0-0 \
  && apt-get clean autoclean && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O install_miniconda.sh && \
  bash install_miniconda.sh -b -p /opt/conda && rm install_miniconda.sh
ENV PATH="/opt/conda/bin:${PATH}"

RUN conda install python~=3.12.0 pip && \
    conda clean --all

# COPY requirements.txt requirements.txt

# RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir datasets==3.4.1
# RUN pip install --no-cache-dir git+https://github.com/PrimeIntellect-ai/prime
RUN pip install --no-cache-dir git+https://github.com/learning-at-home/hivemind
RUN pip install --no-cache-dir git+https://github.com/exo-explore/exo
RUN pip install --no-cache-dir git+https://github.com/bigscience-workshop/petals
RUN pip install --upgrade --no-cache-dir protobuf==5.29.0
RUN rm -rf ~/.cache/pip

RUN rm -f /opt/conda/lib/libgcc_s.so && \
    ln -s libgcc_s.so.1 /opt/conda/lib/libgcc_s.so && \
    conda install -y libgcc-ng

# uv git clone bug, 只能多试几次才成功
RUN curl -sSL https://raw.githubusercontent.com/PrimeIntellect-ai/prime/main/scripts/install/install.sh -o prime_install.sh
RUN bash prime_install.sh
RUN apt-get clean autoclean && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*/

# Python Test Tools
RUN pip install --no-cache-dir \
pytest==8.3.5 \
pytest-forked \
pytest-asyncio==0.16.0 \
pytest-cov \
pytest-timeout \
coverage \
tqdm \
scikit-learn \
codespell==2.2.2 \
psutil \
pytest-xdist \
ruff==0.11.2
COPY exo /exo
WORKDIR /exo
RUN pip install --no-cache-dir -e .
WORKDIR /workspace
RUN pip install --no-cache-dir llvmlite 
RUN pip install --no-cache-dir git+https://github.com/tinygrad/tinygrad.git@a13a43c
RUN rm -rf ~/.cache/pip
# RUN conda install -c conda-forge gcc=12.1.0
# CMD ["bash"]
# CMD ["tail", "-f", "/dev/null"]

# TEST ##################
# prime test ####
# git clone https://github.com/PrimeIntellect-ai/prime.git
# cd prime
# source $HOME/.local/bin/env
# uv run pytest

# hivemind test ####
# cd ../
# git clone https://github.com/learning-at-home/hivemind.git
# cd hivemind

# pytest tests/test_training.py

# exo test ####
# cd ../
# exo

# petals test ####
# https://github.com/bigscience-workshop/petals/wiki/Launch-your-own-swarm

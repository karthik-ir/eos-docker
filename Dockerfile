FROM huangminghuang/eos_builder as builder

LABEL author="Karthik <karthik.ir@outlook.com>" \
  maintainer="Karthik <karthik.ir@outlook.com>" \
  version="0.0.1" \
  description="This is an eosio/eos image"

# Install softfloat (OPTIONAL)
RUN git clone --depth 1 --single-branch --branch master https://github.com/ucb-bar/berkeley-softfloat-3.git \
    && cd berkeley-softfloat-3/build/Linux-x86_64-GCC \
    && make -j${nproc} SPECIALIZE_TYPE="8086-SSE" SOFTFLOAT_OPS="-DSOFTFLOAT_ROUND_EVEN -DINLINE_LEVEL=5 -DSOFTFLOAT_FAST_DIV32TO16 -DSOFTFLOAT_FAST_DIV64TO32" \
    && mkdir -p /opt/berkeley-softfloat-3 && cp softfloat.a /opt/berkeley-softfloat-3/libsoftfloat.a \
    && mv ../../source/include /opt/berkeley-softfloat-3/include && cd - && rm -rf berkeley-softfloat-3

ENV SOFTFLOAT_ROOT /opt/berkeley-softfloat-3

# Install OpenSSL & IDE components
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install openssl libgtk2.0-0 libxss-dev libgconf-2-4 libasound2 libxrender1 libxtst6 libxi6 xauth && rm -rf /var/lib/apt/lists/*

# Install EoS from source
RUN git clone -b dawn-2.x --depth 1 https://github.com/EOSIO/eos.git --recursive \
    && cd eos \
    && cmake -H. -B"/opt/eos/build" -GNinja -DCMAKE_BUILD_TYPE=Release -DEOS_LIBBSONCXX=/usr/local/lib/libbsoncxx.so -DEOS_LIBMONGOCXX=/usr/local/lib/libmongocxx.so -DWASM_LLVM_CONFIG=/opt/wasm/bin/llvm-config -DCMAKE_CXX_COMPILER=clang++ \
       -DCMAKE_C_COMPILER=clang -DCMAKE_INSTALL_PREFIX=/opt/eos  -DSecp256k1_ROOT_DIR=/usr/local \
    && cmake --build /opt/eos/build --target install

# Install Boost
RUN wget https://dl.bintray.com/boostorg/release/1.64.0/source/boost_1_64_0.tar.bz2 -O - | tar -xj \
    && cd boost_1_64_0 \
    && ./bootstrap.sh --prefix=/usr/local \
    && echo 'using clang : 4.0 : clang++-4.0 ;' >> project-config.jam \
    && ./b2 -d0 -j4 --with-thread --with-date_time --with-system --with-filesystem --with-program_options \
       --with-signals --with-serialization --with-chrono --with-test --with-context --with-locale --with-coroutine --with-iostreams \
 	toolset=clang link=static install \
    && cd .. 

COPY ./start_eosd.sh /opt/eos/bin/start_eosd.sh

RUN chmod +x /opt/eos/bin/start_eosd.sh

ENV LD_LIBRARY_PATH /usr/local/lib
ENV CC clang
ENV CXX clang++

VOLUME /opt/eos/data-dir
VOLUME /opt/clion

ENV PATH /opt/clion/bin:/opt/eos/build/install/bin/:/opt/eos/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin



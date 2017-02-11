#!/usr/bin/bash

if [ ! -e v1.0.0-rc2.tar.gz ]; then
	curl -O -L https://github.com/tensorflow/tensorflow/archive/v1.0.0-rc2.tar.gz
fi	
rm -rf tensorflow-1.0.0-rc2
rm -rf tmp
mkdir tmp

tar -axf v1.0.0-rc2.tar.gz

pushd tensorflow-1.0.0-rc2
	./configure < ../answers.txt
	bazel clean
	bazel build -c opt --copt=-g1 --copt=-Wno-sign-compare --copt=-O3 //tensorflow/tools/pip_package:build_pip_package
	bazel-bin/tensorflow/tools/pip_package/build_pip_package $PWD/../tmp/
	mv ../tmp/tensorflow-1.0.0rc2-cp36-cp36m-linux_x86_64.whl  ../tmp/tensorflow-1.0.0rc2-cp36-cp36m-linux_x86_64.whlgeneric
	export TF_BUILD_MAVX=MAVX2
	./configure < ../answers.txt
	bazel clean
	bazel build -c opt --copt=-mavx2 --copt=-O3 --copt=-march=haswell --copt=-mfma --copt=-g1  //tensorflow/tools/pip_package:build_pip_package
	bazel-bin/tensorflow/tools/pip_package/build_pip_package $PWD/../tmp/
	mv ../tmp/tensorflow-1.0.0rc2-cp36-cp36m-linux_x86_64.whl  ../tmp/tensorflow-1.0.0rc2-cp36-cp36m-linux_x86_64.whlavx2
	export TF_BUILD_MAVX=MAVX512
	./configure < ../answers.txt
	bazel clean
	bazel build -c opt --copt=-mavx512 --copt=-O3 --copt=-march=skylake-avx512 --copt=-mfma --copt=-g1  //tensorflow/tools/pip_package:build_pip_package
	bazel-bin/tensorflow/tools/pip_package/build_pip_package $PWD/../tmp/
	mv ../tmp/tensorflow-1.0.0rc2-cp36-cp36m-linux_x86_64.whl  ../tmp/tensorflow-1.0.0rc2-cp36-cp36m-linux_x86_64.whlavx512
popd

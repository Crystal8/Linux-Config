#!/bin/bash

DIR=`dirname $(realpath $0)`
echo $DIR
cd $DIR
echo "installing golang in $DIR ..."
export GOROOT=/usr/local/go
export GOPATH=`pwd`
export GOBIN=$GOPATH/bin
export GOINGPATH=`pwd`
export PATH=$PATH:$GOROOT/bin:$GOBIN
echo "GOROOT: $GOROOT"
echo "GOPATH: $GOPATH"
echo "GOINGPATH: $GOINGPATH"
echo "GOBIN: $GOBIN"
echo "PATH: $PATH"

#编译生成protoc
pushd ./
protoc_tar_name=protobuf-3.1.0
cd tarballs/ || exit
tar -zxf ${protoc_tar_name}.tar.gz
cd ${protoc_tar_name}/ || exit
./configure
make
cp src/protoc ../../bin/
cd ../
#清理干净编译目录
rm -rf ${protoc_tar_name}
popd

cd src || exit

echo "installing vim-go binaries ..."
go install github.com/nsf/gocode || exit
go install github.com/alecthomas/gometalinter
go install golang.org/x/tools/cmd/goimports
go install golang.org/x/tools/cmd/guru
go install golang.org/x/tools/cmd/gorename
go install github.com/golang/lint/golint
go install github.com/rogpeppe/godef
go install github.com/kisielk/errcheck
go install github.com/jstemmer/gotags
go install github.com/klauspost/asmfmt/cmd/asmfmt
go install github.com/fatih/motion
go install github.com/fatih/gomodifytags
go install github.com/zmb3/gogetdoc
go install github.com/josharian/impl

echo "installing protobuf ..."
go install github.com/golang/protobuf/proto
go install github.com/golang/protobuf/protoc-gen-go

echo "generating go proto: imagent, oidb"
GEN_PROTO_LIB going/proto/imagent
GEN_PROTO_LIB going/proto/oidb

#生成初始化go环境的脚本
cd $DIR
echo "export GOROOT=$GOROOT" > init_go.sh 
echo "export GOPATH=$GOPATH" >> init_go.sh
echo "export GOINGPATH=$GOINGPATH" >> init_go.sh
echo "export GOBIN=$GOBIN" >> init_go.sh
echo "export PATH=$PATH:$GOBIN" >> init_go.sh
echo "alias auto_go='${DIR}/tools/attr_go.py'" >> init_go.sh

echo "init /etc/profile.d/init_go.sh ..."
cp ./init_go.sh /etc/profile.d/
cpstatus=$?
if [ ${cpstatus}!=0 ];then 
	echo "cp init_go.sh to /etc/profile.d/ fail, please try later yourself"
    if [ `whoami` != "root" ];then
        echo "try: su root and cp ./init_go.sh /etc/profile.d/"
    fi
fi

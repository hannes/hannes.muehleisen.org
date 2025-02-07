#!/bin/bash -e

OS=$(uname -s)
ARCH=$(uname -m)


command -v curl >/dev/null 2>&1 || { echo >&2 "Required tool curl could not be found  Aborting."; exit 1; }
command -v gzip >/dev/null 2>&1 || { echo >&2 "Required tool gzip could not be found  Aborting."; exit 1; }

# figure out latest version
VER=`curl -s https://duckdb.org/data/duckdb-releases.csv | cut -d , -f 2 | head -2 | tail -1`
eval PREFIX="~/.duckdb/cli"
INST="${PREFIX}/${VER}"
LATEST="${PREFIX}/latest"

DIST=

if [ "${OS}" = "Linux" ]
then
    if [ "${ARCH}" = "x86_64" -o "${ARCH}" = "amd64" ]
    then
        DIST=linux-amd64
    elif [ "${ARCH}" = "aarch64" -o "${ARCH}" = "arm64" ]
    then
        DIST=linux-aarch64
    fi
elif [ "${OS}" = "Darwin" ]
then
    DIST=osx-universal
fi

if [ -z "${DIST}" ]
then
    echo "Operating system '${OS}' / architecture '${ARCH}' is unsupported." 1>&2
    exit 1
fi



URL="https://github.com/duckdb/duckdb/releases/download/v${VER}/duckdb_cli-${DIST}.gz"
echo
echo "*** DuckDB Linux/MacOS installation script, version ${VER} ***"
echo
echo
echo "         .;odxdl,            "
echo "       .xXXXXXXXXKc          "
echo "       0XXXXXXXXXXXd  cooo:  "
echo "      ,XXXXXXXXXXXXK  OXXXXd "
echo "       0XXXXXXXXXXXo  cooo:  "
echo "       .xXXXXXXXXKc          "
echo "         .;odxdl,  "
echo 
echo

if [ -f "${INST}/duckdb" ]; then
    echo "Destination binary ${INST}/duckdb already exists"
else     
    echo
    read -p "Install ${URL} to ${INST}/duckdb? [y/n] (default: y)" yn

    case $yn in
        [Nn]* ) echo "aborting" 1>&2; exit 1;;
    esac

    mkdir -p $INST

    if [ ! -d "$INST" ]; then
        echo "Failed to create install directory ${INST}." 1>&2
        exit 1
    fi

    curl -L --progress-bar "${URL}" | gzip -d -q > $INST/duckdb && chmod a+x ${INST}/duckdb || exit 1


    ln -s $INST $LATEST || exit 1

    if [ ! -f "${INST}/duckdb" ]; then
        echo "Failed to download/unpack binary at ${INST}/duckdb" 1>&2
        exit 1
    fi


    # lets test if this works
    TEST=`${INST}/duckdb -noheader -init /dev/null -csv -batch -s "select 42"`

    if  [ ! "$TEST" = "42" ]; then
        echo "Failed to execute installed binary :/ ${INST}." 1>&2
        exit 1  
    fi
    echo
    echo "Successfully installed DuckDB binary to ${INST}/duckdb"
    echo "  with a link from                      ${LATEST}/duckdb"
fi


echo
echo "Hint: Append the following line to your shell profile:"
echo "export PATH='${LATEST}':\$PATH"
echo
echo "To launch DuckDB now, type"
echo "${LATEST}/duckdb"



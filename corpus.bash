#!/usr/bin/env bash
# Usage: bash corpus.bash
# Downloads and unpacks the spam corpus, if not present
# Runs rake corpus:verify_all && exit 0
# Usage: bash corpus.bash confirm_failures
# Loops over email failures and outputs success or exception class
set -e
function download_corpus {
  curl --referer http://plg.uwaterloo.ca/cgi-bin/cgiwrap/gvcormac/foo \
       -O http://plg.uwaterloo.ca/cgi-bin/cgiwrap/gvcormac/trec05p-1.tgz && \
  curl -O http://plg.uwaterloo.ca/~gvcormac/treccorpus/trec05p-1.MD5SUM && \
  curl -O http://plg.uwaterloo.ca/~gvcormac/treccorpus/README.html
  expected_hash=$(cat trec05p-1.MD5SUM | cut -d' ' -f1)
  received_hash=$(cat trec05p-1.tgz | openssl dgst -md5)
  if [ $expected_hash = $received_hash ]
  then
    echo "Downloaded files with expected md5"
    tar xzf trec05p-1.tgz && true
  else
    echo "Downloaded files failed to match expected md5"
    echo "'$expected_hash' != '$received_hash'"
    rm -f trec05p-1.tgz
    rm -f trec05p-1
    false
  fi
}
function not_file_exists {
  [[ ! -s $1 ]] && [[ ! -d $1 ]]
}
function file_exists {
  [[ -s $1 ]] || [[ -d $1 ]]
}
function run_test {
  if not_file_exists "corpus/spam/trec05p-1"
  then
    mkdir -p corpus/spam # LOCATION
    mkdir -p spec/fixtures/emails/failed_emails # SAVE_TO
    echo "Deleting any previously failed emails"
    rm -f spec/fixtures/emails/failed_emails/*
    cd corpus/spam
    echo "Downloading corpus"
    download_corpus
    success=$?
    cd -
    if [[ success == false ]]
    then
      exit 1
    elif not_file_exists "corpus/spam/trec05p-1"
    then
      exit 2
    fi
  fi
  rake corpus:verify_all && exit 0
}
case "$1" in
    confirm_failures)
        for file in spec/fixtures/emails/failed_emails/*;
          do env FILE=$file ruby -Ilib -rmail -e 'puts Mail.read(ENV["FILE"]) && "success" rescue $!.class';
        done
    ;;
    *)
        run_test
    ;;
esac

#!/bin/bash

failed_items=""
function install_package() {
echo EXECUTING: brew install $1 $2
brew install $1 $2
[ $? -ne 0 ] && $failed_items="$failed_items $1" # package failed to install.
}
brew tap caskroom/cask
brew tap homebrew/core
brew tap jlhonora/lsusb
install_package android-sdk ''
install_package ant ''
install_package apktool ''
install_package apr ''
install_package apr-util ''
install_package autoconf ''
install_package automake ''
install_package autossh ''
install_package dex2jar ''
install_package exiftool ''
install_package ffmpeg ''
install_package findbugs ''
install_package gdbm ''
install_package git ''
install_package git-review ''
install_package gnupg ''
install_package gradle ''
install_package lame ''
install_package leiningen ''
install_package libtool ''
install_package libvo-aacenc ''
install_package libyaml ''
install_package maven ''
install_package openssl ''
install_package pkg-config ''
install_package pngcheck ''
install_package python ''
install_package python3 ''
install_package readline ''
install_package repo ''
install_package ruby ''
install_package sqlite ''
install_package sqlite-analyzer ''
install_package subversion ''
install_package wget ''
install_package x264 ''
install_package xvid ''
install_package xz ''
install_package youtube-dl ''
[ ! -z $failed_items ] && echo The following items failed to install: && echo $failed_items

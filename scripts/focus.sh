#!/bin/sh

wid=$(lsw | sed -n $1p)

wtf $wid

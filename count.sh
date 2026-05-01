#!/usr/bin/env zsh

print "Files"
find ../BlueskyKit -name "*.swift" | wc -l

print "Lines of code"
find ../BlueskyKit -name "*.swift" -exec cat {} + | wc -l


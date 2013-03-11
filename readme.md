# Bandwidth thing

Fetch monthly bandwidth summaries from your dd-wrt router

need to create a config.yml in the same directory with the following keys:

 * `username` -- the username to log into dd-wrt with
 * `password` -- the password to log into dd-wrt with
 * `host` -- the hostname or IP of your dd-wrt router

Then just run `ruby bandwidth.rb` to fetch the info.

## TODO

 * create histogram
 * read daily breakdowns
 * graph it using some kind of library somehow.

## Author

Written by Spike Grobstein (me@spike.cx). https://spike.grobste.in.
&copy; 2013 Spike Grobstein

https://github.com/spikegrobstein/bandwidth

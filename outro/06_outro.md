!SLIDE smbullets
# How to use these tools in the real world?

* use some preliminary GC configuration (e.g. Twitter's)
* use the middleware in your app (e.g. on staging with production
  settings)
* enable GC runs after each request
* walk through some feature scenarios and examine the logs
* optimize actions which create too many new objects
* repeat these steps until you're satisfied

!SLIDE bullets incremental
# Easy ways to optimize:

* Reduce number of objects
* Avoid creating high number of complex objects
* Do not require everything (test and development gems in production)

!SLIDE small
# Thank you! Questions?

## Me: [github.com/lackac](https://github.com/lackac/)
## This Presentation:
## [bprb-objectspace-cleanup.heroku.com](http://bprb-objectspace-cleanup.heroku.com/)
## Source:
## [github.com/lackac/showoff-objectspace-cleanup](https://github.com/lackac/showoff-objectspace-cleanup)

#### Images from flickr
#### [http://www.flickr.com/photos/cindy47452/441316645/](http://www.flickr.com/photos/cindy47452/441316645/)
#### [http://www.flickr.com/photos/ce_sera/159171922/](http://www.flickr.com/photos/ce_sera/159171922/)
#### [http://www.flickr.com/photos/jeffyoungstrom/3602384021/](http://www.flickr.com/photos/jeffyoungstrom/3602384021/)

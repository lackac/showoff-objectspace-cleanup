!SLIDE smbullets
# How to use these tools in the real world?

* use some preliminary GC configuration (e.g. Twitter's)
* use the middleware in your app (e.g. on staging with production
  settings)
* enable gc runs after each request
* walk through some feature scenarios and examine the logs
* optimize actions which create too many new objects
* repeat these steps until you're satisfied

!SLIDE bullets incremental
# Easy ways to optimize:

* Reduce number of objects
* Avoid creating high number of complex objects
* Do not require everything
* Optimize GC settings

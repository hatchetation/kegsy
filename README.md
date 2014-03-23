# kegsy

## what

A sinatra web app that serves usage statistics for Simply Measured's office Keezer, Kegsy!

## definitions

### beer

It's delicious.

Beer in our system is defined as a single recipe that is produced by a brewer or brewery and may or may not conform to a BJCP style. 

### keg

How we keep the beer.

Kegs in our system are defined as vessels that store beer that is ready for consumption.

### line

What gives us the beer.

Lines in our system are defined as the mechanism in which transfers the beer from the keg to the end user.  This conceptually encapsulates everything from the Sankey couplers, plastic tubing, and faucets.  Also commonly refered to as a "tap", a "line" may undergo multiple periods of maintainence over time.

### serving

Now you have beer.

Servings in our system are defined as acquiring any amount of beer from a "line".  Sizes of servings are more acurately identified by the length of time in which they were pulling beer from the "line".  Sizes of servings may vary, but assuming a semi-constant flowrate between lines, we can make a good estimate of how big a serving was depending on when the line was opened and when the line was closed.

## api

  - `GET /healtcheck` Learn about kegsy's current status!
  - `GET /beers` Find out what beers kegsy has served throughout history
  - `GET /beers/:id` Find out how a particular beer has been consumed, how often it's been served, and other interesting metadata.
  - `GET /kegs` Learn about every keg that we have ever installed in Kegsy
  - `GET /kegs/:id` Learn about a specific keg on the system.
  - `GET /lines` Get information on all the current lines in our kegsy's system
  - `GET /lines/:id` Get information on a particular line
  - `GET /servings` See all servings throughout kegsy's history
  - `GET /serving/:id` See a particular serving and corresponding metadata.

## usage

This web app is intended to be ran on a Rasberry Pi in a long-running ruby process.  To run the application, we first need to satisfy a few gem dependencies:

```
bundle install
```

Then boot up the app with the following command:

```
bundle exec rackup
```

That's it! 

## roadmap

  - Registered User Data (facilitated by RFID-enabled cups)?
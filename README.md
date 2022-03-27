# GeneratoRSS

## What is it?

GeneratoRSS generates [RSS](https://en.wikipedia.org/wiki/RSS) feeds from:
* Twitter users
* Youtube channels
* Discord channels
* iTunes podcasts
* Websites such as tumblr, blogger and medium
* Handful of other websites

## Features

One unique RSS feed URL per Twitter user, Youtube channel, Discord channel, website, ...

One unique combined RSS feed URL with everything in it.

Unlimited Filtering.

30 day data retention (see (`Subscription::RETENTION`).

30 minute refresh (see `config/schedule.yml`).

## Tech

Ruby on Rails 7

PostgreSQL

Sidekiq

## Install

Clone this repo.

Create a `.env` in the root path with:
* `TWITTER_BEARER_TOKEN`
* `DISCORD_AUTHORIZATION`
* development, test and production database keys
  See `config/database.yml` for the exact key names.
  
Open up a rails console and create a user, see `db/seed.rb` for an example.

Start the server, log in and start adding your things.

Start adding the unique RSS feed URLS to your favourite RSS reader.
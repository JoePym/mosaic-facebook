#Mosaic Facebook API gem [![Build Status](https://travis-ci.org/mosaicxm/mosaic-facebook.png?branch=master)](https://travis-ci.org/mosaicxm/mosaic-facebook)

This gem is designed to make integrating a Facebook application easy into your ruby program.


## Installation

If using Bundler, just add it to your Gemfile

    gem 'mosaic-facebook'

If you want to use it from other applications, just install it as a gem, then require it like normal.

## Usage

For almost any use case of the application, you will want to instantiate a new Facebook Application object.

    app = Mosaic::Facebook::Graph::Application.new(:id => FB_CONFIG["client_id"], :secret => FB_CONFIG["client_secret"])

You will then want to retrieve the oauth access token to allow you to make authenticated calls to the API.

   @access_token = app.access_token

### Logging a user in with Facebook

To start with, you will want to redirect the user to the Facebook authentication page in your controller.

    facebook_client_id = ** your facebook client id **
    redirect_uri = ** the place where Facebook will redirect them back **
    scope = ** the permissions you are asking for, comma separated string ***
    redirect_to "http://www.facebook.com/dialog/oauth?client_id=#{facebook_client_id}&redirect_uri=#{CGI::escape(redirect_uri)}&scope=#{scope}"

They will then be prompted to authorize your application with your permissions, and be redirected back to your redirect URI. You want to then verify that this was a
valid callback, by using the authorize method on the application

    user = app.authorize(params[:code], redirect_uri)

This call will return a Mosaic::Facebook::Graph::User object, containing the details of the user. For an example call:

    user.name # returns the name of the user
    user.birthday # returns the user's birthday.

You can also examine meta-data about a user:

    user.likes # returns all the information about the likes of a user.

### Checking that a user has liked your facebook page

Alternately, you can query the like model directly, if you want to find out if a user liked a page

    page_id = ** your facebook page id **
    Mosaic::Facebook::Graph::Like.find_by_id(user.facebook_id, page_id, :access_token => user.oauth_token).any?

### Grabbing a list of all the posts for a page

First, you'll need to record the page

    since_time = Time.now.to_i # If you don't pass a since time, you'll get all posts in the history of the page
    page_id = ** your page id **
    page = Mosaic::Facebook::Graph::Page.new(:id => page_id).feed.all(:access_token => app.access_token, :since => since_time)

You can then iterate through the posts , grabbing all the fields of each post

    page.feed.all each do |post|
      from = post.from.all(:fields => 'name,username,picture')
      puts post.id.to_s
      puts post.message
      puts post.created_time
      puts from.username.blank? ? from.name : from.username
      puts from.picture # profile photo
      case post.type
      when 'link'
        puts post.link
      when 'photo'
        puts post.picture
      when 'video'
        puts post.source
      end
    end

### Grabbing a list of events from a page

Take the page we recorded earlier, and much like the post feed, we can now grab the event feed

    events = page.events.all({:access_token => app.access_token})
    events.each do |event|
      puts event.name
      puts event.description
      puts event.start_time
      puts event.end_time
      puts event.location
      puts event.venue
    end

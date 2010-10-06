require 'rss'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

categories = Category.create([
  { :title => 'News', :description => 'News', :shortname => 'news'},
  {:title => 'Reviews', :description => 'Reviews', :shortname => 'reviews'},
  {:title => 'Videos', :description => 'Videos', :shortname => 'videos'},
  {:title => 'How-to', :description => 'How-to', :shortname => 'how-to'},
  {:title => 'Tools', :description => 'Tools', :shortname => 'tools'},
  {:title => 'Social', :description => 'Social', :shortname => 'social'}])

User.create(:login => 'admin', :email => 'admin@smallclouds.com', :password => 'admin', :admin => true )

    #@feeds1 = RSS::Parser.parse(open('http://feeds.feedburner.com/entrepreneur/latest').read, false).items

    # Moved this to a cron job later
    feeds = []
    feeds << RSS::Parser.parse(open('http://feedproxy.google.com/typepad/alleyinsider/silicon_alley_insider').read, false).items
    feeds.flatten!

    unless feeds.blank?
      feeds.each do |feed|
        content = Content.create(:title => feed.title, :source => feed.link, :body => feed.description, :category => categories.first)
      end
    end

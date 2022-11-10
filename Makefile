init:
	bundle install

start: init
	bundle exec ruby src/start.rb
